# Docker image for Magento 2 with Becopay gateway


This repo converts the [long installation guide](http://devdocs.magento.com/guides/v1.0/install-gde/bk-install-guide.html) of Magento 2 into simple Docker image to use.


__Note__ This docker image uses the *Contributing developer* profile to install Magento, so it has limitations. See more details [here](http://devdocs.magento.com/guides/v2.0/install-gde/bk-install-guide.html).

**Please note: this Docker image is for development and testing only, not for production use. Setting up a Magento 2 production server requires more configurations. Please refer to [official documentations](http://devdocs.magento.com/guides/v2.2/config-guide/deployment/).**

## Magento 2 installation types

Magento 2 has three different ways to [install](http://devdocs.magento.com/guides/v2.0/install-gde/bk-install-guide.html), for users, integrators and developers. This Docker image uses **integrator** as the default installation type, so the **Web Setup Wizard** can be used.


## Quick start

The easiest way to start Magento 2 with MySQL is using [Docker Compose](https://docs.docker.com/compose/). Just clone this repo and run following command in the root directory. The default `docker-compose.yml` uses MySQL and phpMyAdmin.

```
$ docker-compose up -d
```

For admin username and password, please refer to the file `env`. You can also update the file `env` to update those configurations. Below are the default configurations.

```
MYSQL_HOST=db
MYSQL_ROOT_PASSWORD=myrootpassword
MYSQL_USER=magento
MYSQL_PASSWORD=magento
MYSQL_DATABASE=magento

MAGENTO_LANGUAGE=en_GB
MAGENTO_TIMEZONE=Pacific/Auckland
MAGENTO_DEFAULT_CURRENCY=USD
MAGENTO_URL=http://local.magento
MAGENTO_BACKEND_FRONTNAME=admin
MAGENTO_USE_SECURE=0
MAGENTO_BASE_URL_SECURE=0
MAGENTO_USE_SECURE_ADMIN=0

MAGENTO_ADMIN_FIRSTNAME=Admin
MAGENTO_ADMIN_LASTNAME=MyStore
MAGENTO_ADMIN_EMAIL=amdin@example.com
MAGENTO_ADMIN_USERNAME=admin
MAGENTO_ADMIN_PASSWORD=Admin123456
```

For example, if you want to change the default currency, just update the variable `MAGENTO_DEFAULT_CURRENCY`, e.g. `MAGENTO_DEFAULT_CURRENCY=USD`.

You can find all available options in the official [setup guide](http://devdocs.magento.com/guides/v2.0/install-gde/install/cli/install-cli-install.html#instgde-install-cli-magento). If you need more options, fork this repo and add them in `bin\install-magento`.


## Installation

After starting the container, you'll see the setup page of Magento 2. You can use the script `install-magento` to quickly install Magento 2. The installation script uses the variables in the `env` file.

### Magento 2

```
$ docker exec -it <container_name> install-magento
```

### Sample data

```
$ docker exec -it <container_name> install-sampledata
```

### Database

The default `docker-compose.yml` uses MySQL as the database and starts [phpMyAdmin](https://www.phpmyadmin.net/). The default URL for phpMyAdmin is `http://localhost:8580`. Use MySQL username and password to log in.

## Configure the Becopay plugin 

You must have a Becopay merchant account to use this plugin.  It's free and easy to [sign-up for a becopay merchant account](https://becopay.com/en/merchant-register/).

Configure the Becopay plugin in your Magento admin panel: 

1. Log in to your Magento admin panel. 
2. In the left navigation bar, go to ``Stores > Configuration.``
3. In the menu, go to ``Sales > Payment Methods.``
4. Click Required Settings and fill out the following fields: 

* __Enable/Disable__ - Select ``Enable`` to enable Becopay Payment Gateway.
* __Title__ - Allows you to determine what your customers will see this payment option as on the checkout page.
* __Mobile__  - Enter the phone number you registered in the Becopay here.If you don't have Becopay merchat account register [here](https://becopay.com/en/merchant-register/).
* __Api Base Url__  - Enter Becopay api base url here. If you don't have Becopay merchat account register [here](https://becopay.com/en/merchant-register/).
* __Merchant Api Key__  - Enter your Becopay Api Key here. If you don't have Becopay merchat account register [here](https://becopay.com/en/merchant-register/).
* __Order Status after payment__ - Status given to orders after the payment has been completed
* __Payment From Applicable Countries__ - Payment options limited to specific countries
* __Sort Order__ - Add Gateway list sort number
* Click on __Save Config__ For the changes you made to be effected.

### Plugin Callback URL
```https://your-site/becopay/payment/callback/?orderId=```

## FAQ

### Where is the database?

Magento 2 cannot run with a database. This image is for Magento 2 only. It doesn't contain MySQL server. MySQL server should be started in another container and linked with Magento 2 container. It's recommended to use Docker Compose to start both containers. You can also use [Kubernetes](https://kubernetes.io/) or other tools.

### Why accessing http://local.magento?

For development and testing in the local environment, using `localhost` as Magento 2 URL has some issues. The default `env` file use `http://local.magento` as the value of `MAGENTO_URL`. You need to [edit your `hosts` file](https://support.rackspace.com/how-to/modify-your-hosts-file/) to add the mapping from `local.magento` to `localhost`. You can use any domain names as long as it looks like a real domain, not `localhost`.

If `localhost` doesn't work, try using `127.0.0.1`.

```
127.0.0.1    local.magento
```

### How to update Magento 2 installation configurations?

Depends on how the container is used,

* When using the GUI setup page of Magento 2, update configurations in the UI.
* When using the script, update configurations in the `env` file. 
* When starting Magento 2 as a standalone container, use `-e` to pass environment variables.

### Why getting access denied error after changing the default DB password?

If you change the default DB password in `env` file and get the access denied error when installing Magento 2.

## Becopay Support:

* [GitHub Issues](https://github.com/becopay/becopay-magento2/issues)
  * Open an issue if you are having issues with this plugin
* [Support](https://becopay.com/en/support/#contact-us)
  * Becopay support

## Contribute

Would you like to help with this project?  Great!  You don't have to be a developer, either.  If you've found a bug or have an idea for an improvement, please open an [issue](https://github.com/becopay/becopay-magento2/issues) and tell us about it.

If you *are* a developer wanting contribute an enhancement, bug fix or other patch to this project, please fork this repository and submit a pull request detailing your changes. We review all PRs!

This open source project is released under the [Apache 2.0 license](https://opensource.org/licenses/Apache-2.0) which means if you would like to use this project's code in your own project you are free to do so.  Speaking of, if you have used our code in a cool new project we would like to hear about it!  [Please send us an email](mailto:io@becopay.com).

## License

Please refer to the [LICENSE](https://opensource.org/licenses/Apache-2.0) file that came with this project.
