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

## Contacts
- Issues: https://github.com/debloper/xplex/issues
- Email: help@xplex.me

## Description

![xplex social banner](https://raw.githubusercontent.com/debloper/xplex/refs/heads/master/docs/public/preview.png)

**xplex** is your personal, open source, multi-streaming server to simultaneously stream to as many platforms as you want to.

### What does it do?

**xplex** acts as a bridge between your streaming software (e.g. OBS, XSplit etc.) and the streaming services (e.g. Twitch, YouTube etc.). It takes the stream from your streaming software and goes live on all of the streaming services you’ve confiugured it to—all at once!

### Who is it for?

**xplex** is for content creators who want to reach a wider audience by simultaneously streaming to multiple platforms, without costly subscriptions or complicated setups, while retaining full control of the choice, flexibility, extensibility & the data.

All it takes is starting the droplet with xplex preconfigured & [adding your stream keys](https://xplex.me/setup/postinstall/) to the **xplex<sup>HQ</sup>** dashboard &mdash; no fiddling with command line, no twiddling with configurations.

So **xplex** for any aspiring streamer, who wants to level up their game by reaching a wider audience.

## Getting Started

As you're using DigitalOcean 1-click droplet, there's nothing for you to do to build & install **xplex**. All the hard part of the installation process is already taken care of for you.

All you need to do is to:

- visit the IP address of the droplet from a browser (or just click "Quick Access")
- add the stream keys of all the streaming platform to your instance to **xplex<sup>HQ</sup>**
- and then update your streaming software to use the **xplex** ingest endpoint

**xplex** will handle the rest - it's completely set it and forget it.

> **WARN**: *make sure to not leak the IP address or the stream keys*.

Check out the official docs for more details: https://xplex.me/setup/postinstall/

## License

This directory reuses code from the [upstream repo](https://github.com/digitalocean/marketplace-partners), in order to comply with DigitalOcean's image validation process. The upstream uses Apache 2.0 license.
