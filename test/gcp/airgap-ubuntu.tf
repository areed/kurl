
resource "google_compute_instance" "kurl_test" {
  name         = "kurl-test-${var.id}"
  machine_type = "n1-standard-2"
  zone         = "us-central1-f"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts"
      size  = 200
    }
  }

  network_interface {
    network = "default"
  }

  metadata = {
    ssh-keys = "kurl:${file("/.ssh/id_rsa.pub")}"
  }

  connection {
    type         = "ssh"
    host         = "${google_compute_instance.kurl_test.network_interface.0.network_ip}"
    user         = "kurl"
    private_key  = "${file("/.ssh/id_rsa")}"
    bastion_host = "${google_compute_instance.kurl_bastion.network_interface.0.access_config.0.nat_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "curl -x '${google_compute_instance.kurl_bastion.network_interface.0.network_ip}:3128' -LO https://staging.kurl.sh/bundle/latest.tar.gz",
      "tar xvf latest.tar.gz",
      "sudo bash install.sh airgap",
    ]
  }
}
