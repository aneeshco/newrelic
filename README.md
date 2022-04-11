# NewRelic - Observability as code
Terraform to automate alert and dashboard creation

## set the below environment variable

```bash
export NEW_RELIC_API_KEY="YOUR_API_KEY"
export NEW_RELIC_ACCOUNT_ID="YOUR_ACCOUNT_ID"
export NEW_RELIC_REGION="YOUR REGION"
export TF_VAR_accountid="YOUR_ACCOUNT_ID"
```

## Run Terraform to create alerts and dashboard
```bash
terraform plan
terraform apply
```

## To delete what's created
```bash
terraform destroy
```