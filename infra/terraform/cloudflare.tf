resource "cloudflare_zone" "default" {
  account_id = "7e500c6b62a35103a98003172724a13b"
  plan = "free"
  zone = "wbotelhos.com"
}

resource "cloudflare_record" "root" {
  name    = "wbotelhos.com"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "wbotelhos.github.io"
  zone_id = cloudflare_zone.default.id
}

resource "cloudflare_record" "www" {
  name    = "www"
  proxied = true
  ttl     = 1
  type    = "CNAME"
  value   = "wbotelhos.github.io"
  zone_id = cloudflare_zone.default.id
}

resource "cloudflare_page_rule" "default" {
  actions {
    forwarding_url {
      status_code = 302
      url         = "https://www.wbotelhos.com/$1"
    }
  }

  priority = 1
  status   = "active"
  target   = "https://wbotelhos.com/*"
  zone_id  = cloudflare_zone.default.id
}

resource "cloudflare_zone_settings_override" "default" {
  settings {
    always_online            = "off"
    always_use_https         = "on"
    automatic_https_rewrites = "off"
    brotli                   = "on"
    browser_cache_ttl        = 0
    cache_level              = "basic" # aggressive
    email_obfuscation        = "on"
    http3                    = "on"
    ip_geolocation           = "on"
    min_tls_version          = "1.0"

    minify {
      css  = "off"
      html = "on"
      js   = "off"
    }

    opportunistic_encryption = "off"
    rocket_loader            = "on"

    security_header {
      enabled            = true
      include_subdomains = true
      max_age            = "63072000"
      nosniff            = true
      preload            = true
    }

    ssl             = "full"
    tls_client_auth = "on"
    websockets      = "on"
  }

  zone_id = cloudflare_zone.default.id
}

# Github Domain: https://github.com/settings/pages_verified_domains/wbotelhos.com

resource "cloudflare_record" "github" {
  name    = "_github-pages-challenge-wbotelhos.wbotelhos.com."
  proxied = false
  ttl     = 1
  type    = "TXT"
  value   = "7bbb4842a814ddc851cecc7b34a19b"
  zone_id = cloudflare_zone.default.id
}
