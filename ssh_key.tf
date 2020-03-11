resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = file(var.ssh_public_key)
}
