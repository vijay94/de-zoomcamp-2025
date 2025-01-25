provider "google" {
  credentials = "${file(var.gcp_key)}"
  project     = "logical-vault-448218-u6"
  region      = "europe-north1"
  zone        = "europe-north1-b"
}

resource "google_compute_network" "de_vpc" {
  name                    = "de-zoomcamp-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "de_subnet" {
  name          = "de-zoomcamp-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = "europe-north1"
  network       = google_compute_network.de_vpc.id

  depends_on = [ google_compute_network.de_vpc ]
}

resource "google_compute_instance" "de_workspace" {
  name         = "de-workspace-machine"
  machine_type = "e2-standard-4"
  zone         = "europe-north1-b"
  tags         = ["ssh-vm-de", "tcp-vm-de"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2404-noble-amd64-v20250117"
      size = 30
    }
  }

  metadata_startup_script = "sudo apt-get update;"

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_key)}"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.de_subnet.id

    access_config {
      # Include this section to give the VM an external IP address
    }
  }

  depends_on = [ google_compute_subnetwork.de_subnet ]
}

resource "google_compute_firewall" "ssh_access" {
  name = "allow-ssh-access-de"
  network = google_compute_network.de_vpc.name

  allow {
    protocol = "tcp"
    ports = ["22"]
  }

  source_ranges = [ "0.0.0.0/0" ]
  target_tags = ["ssh-vm-de"]

  depends_on = [ google_compute_network.de_vpc ]
}


resource "google_compute_firewall" "tcp_access" {
  name = "allow-tcp-access-de"
  network = google_compute_network.de_vpc.name

  allow {
    protocol = "tcp"
    ports = ["8080", "80"]
  }

  source_ranges = [ "0.0.0.0/0" ]
  target_tags = ["tcp-vm-de"]

    depends_on = [ google_compute_network.de_vpc ]
}

resource "google_compute_snapshot" "de_workspace_snapshot" {
  count = var.backup ? 1 : 0
  name       = "de-workspace-snapshot"
  source_disk = google_compute_instance.de_workspace.boot_disk[0].source
  depends_on = [ google_compute_instance.de_workspace ]
}
