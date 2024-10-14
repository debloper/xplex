# DigitalOcean 1-click Distribution

> [!NOTE]  
> Check out DigitalOcean's [upstream repo](https://github.com/digitalocean/marketplace-partners) for the latest updates, or the [1-click droplet repo](https://github.com/digitalocean/droplet-1-clicks) for more examples.

For now, the `packer` snapshot generation is a manual process. It may be automated as part of continuous delivery process, after it has been successfully listed on DO marketplace.

> [!IMPORTANT]  
> We are using Ubuntu 22.04 LTS as the base image (instead of 24.04 LTS) because [reasons](https://github.com/digitalocean/marketplace-partners/issues/186).

## Usage

```bash
# install packer: https://developer.hashicorp.com/packer/install
packer plugins install github.com/digitalocean/digitalocean
packer build -var do_token=dop_v1_xyz... template.json
```

## License

This directory reuses code from the [upstream repo](https://github.com/digitalocean/marketplace-partners), in order to comply with DigitalOcean's image validation process. The upstream uses Apache 2.0 license.
