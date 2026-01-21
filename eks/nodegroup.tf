resource "aws_eks_node_group" "nodegroup" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "demo-ng"
  node_role_arn  = aws_iam_role.node_role.arn
  subnet_ids     = aws_subnet.eks_subnets[*].id

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  depends_on = [
    aws_iam_role_policy_attachment.node_policies
  ]
}
