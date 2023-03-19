# Installation

## Procedure

1. Download required items from Tanzu Network
```
export TANZUNET_REFRESH_TOKEN='****************'
./00_download.sh
```

2. Install Cluster Essentials (kapp-controller, carvel tools) on the cluster and the local machine
```
export TANZUNET_USERNAME="mathiase@vmware.com"
export TANZUNET_PASSWORD="**************"
./01_install-cluster-essentials.sh
```

3. Install Tanzu CLI on the local machine
```
./02_install-tanzu-cli.sh
```

4. Relocate TAP images
```
# Source
export TANZUNET_USERNAME="mathiase@vmware.com"
export TANZUNET_PASSWORD='**************'

# Destination
export INSTALL_REGISTRY_HOSTNAME=gcr.io
export INSTALL_REGISTRY_REPO=cso-pcfs-emea-mewald

./03_relocate-images.sh
```

5. Install the TAP Repository on the K8s cluster
```
export INSTALL_REGISTRY_HOSTNAME=gcr.io
export INSTALL_REGISTRY_REPO=cso-pcfs-emea-mewald
./04_install-tap-repo.sh
```

6. Install TAP

Prepare the `secrets.yaml` file:
```
cp tap/secrets-example.yaml tap/secrets.yaml
vim tap/secrets.yaml
```

Configure the installation via `config.yaml`
```
vim tap/config.yaml
```

Install TAP
```
./05_install-or-update-tap.sh
```

7. Get the wildcard DNS name and IP address to set up the record
```
./06_dns-records.sh
```

8. Create TLS certificates
```
./07_tls.sh
```
You can watch the progress via  `kubectl get certs -A`

9. Open your browser at
```
./08_fqdn.sh
```

## Troubleshooting

### TLS Redirect Is Not Working
It is possible the `ConfigMap` `config-network` has not been edited via the
overlay in time, to the change wasn't picked up during installation.

Verify: 
```
kubectl -n cnrs kubectl -n knative-serving get cm config-network -o yaml
```
Fix:
```
kubectl -n knative-serving delete cm config-network
kctrl package installed kick -i cnrs -n tap-install
``` 

### The Learning Center Training Portal Is Not Available
You should be able to reach the built-int workshop at
`https://learning-center-guided.tlc.YOUR_DOMAIN`. If that's not the case, it
might be the `TrainingPortal` resource did not pick up the `Secret` containing
the certificate.

Verify:
```
kubectl get trainingportals
kubectl describe trainingportal learning-center-guided 
```
Fix: 
```
kubectl delete trainingportals learning-center-guided
kctrl package installed kick -i learningcenter-workshops -n tap-install
```

# Uninstall

```
./99_uninstall.sh
```
