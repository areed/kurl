provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
	version = "~> 2.16"
  # credentials comes from env var GOOGLE_CREDENTIALS
}

resource "google_compute_instance" "kurl_bastion" {
  name         = "kurl-test-${var.id}-bastion"
  machine_type = "n1-standard-1"
  zone         = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    ssh-keys = "kurl:${file("/.ssh/id_rsa.pub")}"
  }

	connection {
		type        = "ssh"
		host = "${google_compute_instance.kurl_bastion.network_interface.0.access_config.0.nat_ip}"
		user        = "kurl"
		private_key = "${file("/.ssh/id_rsa")}"
	}
}

resource "google_compute_instance" "kurl_test" {
  name         = "kurl-test-${var.id}"
  machine_type = "n1-standard-2"
  zone         = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
			size = 200
    }
  }

  network_interface {
    network = "default"
  }

  metadata = {
    ssh-keys = "kurl:${file("/.ssh/id_rsa.pub")}"
  }

	connection {
		type        = "ssh"
		host = "${google_compute_instance.kurl_test.network_interface.0.network_ip}"
		user        = "kurl"
		private_key = "${file("/.ssh/id_rsa")}"
		bastion_host = "${google_compute_instance.kurl_bastion.network_interface.0.access_config.0.nat_ip}"
	}

  provisioner "remote-exec" {
    inline = [
			"curl -LO https://staging.kurl.sh/bundle/latest.tar.gz",
			"tar xvf latest.tar.gz",
			"sudo bash install.sh airgap",
		]
  }
}
