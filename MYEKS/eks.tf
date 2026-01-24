resource "aws_eks_cluster" "eks" {
  name = "ed-eks-01"
  version = "1.31"
  role_arn = aws_iam_role.master.arn
lifecycle {
    prevent_destroy = true
  }

  bootstrap_self_managed_addons = false

  vpc_config {
  subnet_ids = [
    aws_subnet.pub_sub1.id,
    aws_subnet.pub_sub2.id
  ]

  endpoint_public_access  = true
  endpoint_private_access = false
}

  
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
    aws_subnet.pub_sub1,
    aws_subnet.pub_sub2,
  ]


}




