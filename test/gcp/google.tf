
provider "google" {
  project = "${var.project}"
  region  = "${var.region}"
  version = "~> 2.16"
  # credentials comes from env var GOOGLE_CREDENTIALS
}
