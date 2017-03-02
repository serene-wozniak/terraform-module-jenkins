node {
  checkout scm
  stage "Terraform Validate" {
    dir("terraform") {
      sh "terraform validate"
    }
  }

  stage "Ansible Validate" {
    dir("ansible") {
      sh("ansible-playbook bootstrap.yml  --syntax-check")
    }
  }
}