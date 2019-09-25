
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
    host        = "${google_compute_instance.kurl_bastion.network_interface.0.access_config.0.nat_ip}"
    user        = "kurl"
    private_key = "${file("/.ssh/id_rsa")}"
  }

  provisioner remote-exec {
    inline = [
      "sudo apt install -y squid",
      "sudo sed -i'.bak' 's/http_access deny all/http_access allow all/' /etc/squid/squid.conf",
      "sudo systemctl restart squid",
    ]
  }
}

output "bastion_public_ip" {
  value = google_compute_instance.kurl_bastion.network_interface.0.access_config.0.nat_ip
}
