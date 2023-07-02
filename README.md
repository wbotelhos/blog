## Setup

```sh
brew install hugo
```

## Run

```sh
hugo server --disableFastRender
```

## Hugo Debug Values

```go
{{ printf "%#v" .Pages }}
```

## Infra Setup

Set Cloudflare credentials

```sh
export CLOUDFLARE_ACCOUNT_ID=
export CLOUDFLARE_API_KEY=
export CLOUDFLARE_EMAIL=
```

Run the script:

```sh
./infra.sh
```
