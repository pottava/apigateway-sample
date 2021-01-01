# Tutorial

## prepare

```bash
project_id="$( gcloud config get-value project )"
project_number="$(gcloud projects describe ${project_id} --format='value(projectNumber)')"
api_name="my-apis"
gateway_name="prod-gateway"
service_account="${project_number}-compute@developer.gserviceaccount.com"
```

```bash
gcloud services enable apigateway.googleapis.com
gcloud services enable servicemanagement.googleapis.com
gcloud services enable servicecontrol.googleapis.com
```

## v1

```bash
gcloud run deploy backend-apis --image gcr.io/pottava/re:v2.0 \
    --set-env-vars ENABLE_GCP=1,ENABLE_AWS=0
```

```bash
api_endpoint="$(gcloud run services describe backend-apis --format 'value(status.url)')"
find resources -type f -name "*.yaml" | xargs sed -ie "s|<backend-apis>|${api_endpoint}|g"
gcloud beta api-gateway api-configs create v1 \
    --api="${api_name}" --openapi-spec=resources/v1.yaml \
    --backend-auth-service-account="${service_account}"
```

```bash
gcloud beta api-gateway gateways create "${gateway_name}" --location=asia-east1 \
    --api="${api_name}" --api-config=v1
open "https://$( gcloud beta api-gateway gateways describe ${gateway_name} \
    --location=asia-east1 --format 'value(defaultHostname)' )"
```

## v2 (API aggregation)

```bash
gcloud run deploy backend-errs --image gcr.io/pottava/errs:v1.1
```

```bash
err_endpoint="$(gcloud run services describe backend-errs --format 'value(status.url)')"
find resources -type f -name "*.yaml" | xargs sed -ie "s|<backend-errs>|${err_endpoint}|g"
gcloud beta api-gateway api-configs create v2 \
    --api="${api_name}" --openapi-spec=resources/v2.yaml \
    --backend-auth-service-account="${service_account}"
```

```bash
gcloud beta api-gateway gateways update "${gateway_name}" --location=asia-east1 \
    --api="${api_name}" --api-config=v2
open "https://$( gcloud beta api-gateway gateways describe ${gateway_name} \
    --location=asia-east1 --format 'value(defaultHostname)' )/errors/400"
```

## v3 (API Key)

```bash
gcloud services enable "${api_name}.apigateway.${project_id}.cloud.goog"
open "https://console.cloud.google.com/apis/api/${api_name}.apigateway.${project_id}.cloud.goog/credentials"
```

```bash
gcloud beta api-gateway api-configs create v3 \
    --api="${api_name}" --openapi-spec=resources/v3.yaml \
    --backend-auth-service-account="${service_account}"
```

```bash
gcloud beta api-gateway gateways update "${gateway_name}" --location=asia-east1 \
    --api="${api_name}" --api-config=v3
open "https://$( gcloud beta api-gateway gateways describe ${gateway_name} \
    --location=asia-east1 --format 'value(defaultHostname)' )"
```
