provider "google" {
    credentials = "${file("Terraform-9de1fd05e54b.json")}"
    project     = "terraform-246806"
    region      = "asia-south1"
}

resource "random_id" "instance_id" {
    byte_length = 8
}

resource "google_compute_instance" "skripsi" {
    name         = "terraform-skirpsi"
    machine_type = "f1-micro"
    zone         = "asia-south1-a"

    boot_disk {
        initialize_params {
            image = "ubuntu-os-cloud/ubuntu-1604-lts"
        }
    }

    metadata_startup_script = "sudo apt-get -y update; sudo apt-get -y dist-upgrade ; sudo apt-get -y install nginx"
    network_interface {
        network = "default"
        access_config {
	    }
    }

}


resource "google_compute_firewall" "default" {
    name    = "nginx-firewall"
    network = "default"

    allow {
        protocol = "tcp"
        ports    = ["80","443"]
    }

    allow {
        protocol = "icmp"
    }
}

output "ip" {
    value = "${google_compute_instance.skripsi.network_interface.0.access_config.0.nat_ip}"
}