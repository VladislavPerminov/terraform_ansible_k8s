# Infrastructure DadJokes avec Terraform, Ansible et Kubernetes

Ce dépôt fournit l'infrastructure nécessaire pour déployer l'application DadJokes sur AWS, en utilisant Terraform pour le provisionnement, Ansible pour la configuration et Kubernetes pour l'orchestration.

## Architecture

L'infrastructure est composée de :

- **VPC (Virtual Private Cloud) :** Réseau privé isolé dans le cloud AWS.
- **Sous-réseau public :** Sous-réseau dans le VPC pour les ressources accessibles publiquement.
- **Groupe de sécurité :** Règles de pare-feu pour contrôler le trafic entrant et sortant.
- **Instance EC2 :** Machine virtuelle pour héberger l'application Node.js.
- **Cluster Kubernetes (EKS) :** (Optionnel) Pour orchestrer et mettre à l'échelle l'application.


## Déploiement

1. **Cloner le dépôt :**
   git clone https://github.com/VladislavPerminov/terraform_ansible_k8s.git


2. **Initialiser Terraform :**

   cd Terraform
   terraform init

3. **Créer le plan Terraform :**

   terraform plan

4. **Appliquer le plan Terraform :**

   terraform apply   

5. **Configurer les serveurs avec Ansible :**

   cd Ansible
   ansible-playbook -i inventory.ini playbooks/main.yml

6. **Déployer sur Kubernetes :**
   cd Kubernetes
   kubectl apply -f .