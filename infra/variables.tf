variable cluster_name {
  description = "Name of the EKS cluster"
  type        = string
}

variable code_owner {
    type        = string
    description = "The owner of this repository."
}

variable environment {
    type        = string
    default     = "dev"
    description = "Name of the environmment to deploy into."
}

variable image {
    type        = string
    description = "Name of the docker image to instantiate the container from."
    default     = "nginx"
}

variable node_group_desired_capacity {
  description = "Initial desired capacity of the node group, lifecycle set to ignore changes that were caused externally"
  type        = number
}

variable node_group_max_capacity {
  description = "Max capacity of the node group"
  type        = number
}

variable node_group_min_capacity {
  description = "Min capacity of the node group"
  type        = number
}

variable region {
    type        = string
    description = "The AWS region to deploy into."
    default     = "ap-southeast-2"
}

variable repository {
    type        = string
    description = "Name of the GitHub repository where the code is stored."
}

variable service {
    type        = string
    description = "Name of the service."
}

