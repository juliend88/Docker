# 5 Minutes Stacks, épisode 26 : Toolbox Beta #

## Episode 26 : Toolbox Beta


The toolbox ( Beta ) is a different stack of everything the team was able to share with you so far.This aims to bring you a set of tools to **unify, harmonize and monitor your tenant**.
In fact it contains a lot of different applications that aims to help you manage day by day of your instances.

This toolbox has been completely developed by the CAT team ( Cloudwatt Automation Team).
The user interface is made ​​with react technology; it base on a CoreOS instance and all applications are deployed via Docker containers on a Kubernetes infrastructure.Also you can install or configure , from the GUI , all the applications on your instances via Ansible playbooks.

To secure maximum toolbox that no port is exposed on the internet except port 22 in order to download a Openvpn configuration file. This method is explained later in the article.


### The Versions

- CoreOS Stable 899.13.0
- Docker 1.10.3
- Zabbix 3.0
- Rundeck 2.6.2
- Graylog 1.3.4
- Nexus 2.12.1-01
- Nginx 1.9.12
- Aptly  0.9.6
- SkyDNS 2.5.3a
- Etcd 2.0.3


### The prerequisites to deploy this stack

These should be routine by now:

 * Internet access
 * A Linux shell
 * A [Cloudwatt account](https://www.cloudwatt.com/cockpit/#/create-contact) with a [valid keypair](https://console.cloudwatt.com/project/access_and_security/?tab=access_security_tabs__keypairs_tab)
 * The tools of the trade: [OpenStack CLI](http://docs.openstack.org/cli-reference/content/install_clients.html)
 * A local clone of the [Cloudwatt applications](https://github.com/cloudwatt/applications) git repository (if you are creating your stack from a shell)

## Size of the instance

By default, the stack deploys on an instance of type "Small" (s1.cw.small-1). A variety of other instance types exist to suit your various needs, allowing you to pay only for the services you need. Instances are charged by the minute and capped at their monthly price (you can find more details on the [Pricing page](https://www.cloudwatt.com/en/pricing.html) on the Cloudwatt website).

Stack parameters, of course, are yours to tweak at your fancy.

### By the way...

If you do not like command lines, you can go directly to the "run it thru the console" section by clicking [here](#console)

## What will you find in the repository

 Once you have cloned the github, you will find in the `bundle-toolbox/` repository:

 * `bundle-toolbox.heat.yml`: HEAT orchestration template. It will be use to deploy the necessary infrastructure.

## Start-up

### Initialize the environment

Have your Cloudwatt credentials in hand and click [HERE](https://console.cloudwatt.com/project/access_and_security/api_access/openrc/).
If you are not logged in yet, you will go thru the authentication screen then the script download will start. Thanks to it, you will be able to initiate the shell accesses towards the Cloudwatt APIs.

Source the downloaded file in your shell. Your password will be requested.

~~~ bash
$ source COMPUTE-[...]-openrc.sh
Please enter your OpenStack Password:

~~~

Once this done, the Openstack command line tools can interact with your Cloudwatt user account.

### Adjust the parameters

With the `bundle-toolbox.heat.yml` file, you will find at the top a section named `parameters`.
This stack to need all of your user information in order to interact with all of your instances will be connected to the *router* of this Toolbox .

**Advice** : So that the toolbox does not have all the rights to your holding , you can create him an account with restricted rights. An account with read rights is sufficient (TENANT_SHOW).
It is in this same file you can adjust the size of the instance by the parameter `flavor`. In order not to have any performance problem, we recommend that you use an instance of type "standard-4". You can also indicate the volume_size who will attach on your stack.

~~~ yaml

heat_template_version: 2013-05-23

description: Toolbox stack for Cloudwatt


parameters:
  keypair_name:
    description: Keypair to inject in instance
    label: SSH Keypair
    type: string

  os_username:
    description: OpenStack Username
    label: OpenStack Username
    type: string

  os_password:
    description: OpenStack Password
    label: OpenStack Password
    type: string

  os_tenant:
    description: OpenStack Tenant Name
    label: OpenStack Tenant Name
    type: string

  os_auth:
    description: OpenStack Auth URL
    default: https://identity.fr1.cloudwatt.com/v2.0
    label: OpenStack Auth URL
    type: string

  domain:
    description: Wildcarded domain, ex example.com must have a *.example.com DNS entry
    label: Cloud DNS
    type: string

  flavor_name:
    default: n1.cw.standard-4
    description: Flavor to use for the deployed instance
    type: string
    label: Instance Type (Flavor)
    constraints:
      - allowed_values:
          - n1.cw.standard-4
          - n1.cw.standard-8
          - n1.cw.standard-12
          - n1.cw.standard-16


  volume_size:
    default: 10
    label: Backup Volume Size
    description: Size of Volume for Toolbox Storage (Gigabytes)
    type: number
    constraints:
      - range: { min: 10, max: 10000 }
        description: Volume must be at least 10 gigabytes

  volume_type:
    default: standard
    label: Backup Volume Type
    description: Performance flavor of the linked Volume for DevKit Storage
    type: string
    constraints:
      - allowed_values:
          - standard
          - performant

 ~~~

### Start Stack

In a shell, run the script `stack-start.sh`:


~~~bash
$ ./stack-start.sh Toolbox
+--------------------------------------+-----------------+--------------------+----------------------+
| id                                   | stack_name      | stack_status       | creation_time        |
+--------------------------------------+-----------------+--------------------+----------------------+
| ee873a3a-a306-4127-8647-4bc80469cec4 |   Toolbox       | CREATE_IN_PROGRESS | 2015-11-25T11:03:51Z |
+--------------------------------------+-----------------+--------------------+----------------------+
~~~
Within **5 minutes** the stack will be fully operational. (Use `watch` to see the status in real-time)

~~~bash
$ watch heat resource-list Toolbox
+-------------------+-------------------------------------------------------------------------------------+---------------------------------+-----------------+----------------------+
| resource_name     | physical_resource_id                                                                | resource_type                   | resource_status | updated_time         |
+-------------------+-------------------------------------------------------------------------------------+---------------------------------+-----------------+----------------------+
| floating_ip       | c683dbfa-3c9a-4cd6-a38d-2839fb203e9c                                                | OS::Neutron::FloatingIP         | CREATE_COMPLETE | 2016-03-15T10:34:01Z |
| network           | b87a5d95-61fb-4586-ba1c-d531d2f638c9                                                | OS::Neutron::Net                | CREATE_COMPLETE | 2016-03-15T10:34:02Z |
| security_group    | 8d7745dd-c517-461a-bf57-b95cc1fcbeba                                                | OS::Neutron::SecurityGroup      | CREATE_COMPLETE | 2016-03-15T10:34:02Z |
| router            | b0977098-3fa4-461a-9a79-6715d3604822                                                | OS::Neutron::Router             | CREATE_COMPLETE | 2016-03-15T10:34:03Z |
| subnet            | 7f531a2c-4a3e-41d3-aa33-64396cb5f2d2                                                | OS::Neutron::Subnet             | CREATE_COMPLETE | 2016-03-15T10:34:04Z |
| ports             | ab7791ee-3a07-4cc3-9a3b-da7cc53fb8aa                                                | OS::Neutron::Port               | CREATE_COMPLETE | 2016-03-15T10:34:09Z |
| toolbox_interface | b0977098-3fa4-461a-9a79-6715d3604822:subnet_id=7f531a2c-4a3e-41d3-aa33-64396cb5f2d2 | OS::Neutron::RouterInterface    | CREATE_COMPLETE | 2016-03-15T10:34:09Z |
| server            | f45d47a2-9686-44a9-9634-22d6012ef497                                                | OS::Nova::Server                | CREATE_COMPLETE | 2016-03-15T10:34:11Z |
| floating_ip_link  | c683dbfa-3c9a-4cd6-a38d-2839fb203e9c-84.39.44.44                                    | OS::Nova::FloatingIPAssociation | CREATE_COMPLETE | 2016-03-15T10:34:34Z |
+-------------------+-------------------------------------------------------------------------------------+---------------------------------+-----------------+----------------------+

~~~
The `start-stack.sh` script takes care of running the API necessary requests to execute the normal heat template which:

* Starts an CoreOS based instance
* create and attach a block volume,
* Launch **toolbox** container
* Launch **SkyDNS** container

<a name="console" />

## All of this is fine, but...

### You do not have a way to create the stack from the console?

We do indeed! Using the console, you can deploy a Pfsense server:

1.	Go the Cloudwatt Github in the [applications/bundle-trusty-cozycloud](https://github.com/cloudwatt/applications/tree/master/bbundle-trusty-cozycloud) repository
2.	Click on the file named `bundle-toolbox.heat.yml`
3.	Click on RAW, a web page will appear containing purely the template
4.	Save the file to your PC. You can use the default name proposed by your browser (just remove the .txt)
5.  Go to the « [Stacks](https://console.cloudwatt.com/project/stacks/) » section of the console
6.	Click on « Launch stack », then « Template file » and select the file you just saved to your PC, and finally click on « NEXT »
7.	Name your stack in the « Stack name » field
8.	Enter the name of your keypair in the « SSH Keypair » field
9.  Write a passphrase that will be used for encrypting backups
10.	Choose your instance size using the « Instance Type » dropdown and click on « LAUNCH »

The stack will be automatically generated (you can see its progress by clicking on its name). When all modules become green, the creation will be complete. Only remains for you to retrieve the configuration file **Openvpn** `cloud.ovpn`.

```bash
scp -i ~/.ssh/your_keypair core@FloatingIP:cloud.ovpn .
```
If this is not available , wait **2 minutes** that the entire stack is available.
Once this is done add the configuration file to your OpenVPN client and connect to your toolbox.

It's (already) over !

### A one-click chat sounds really nice...

... Good! Go to the [Apps page](https://www.cloudwatt.com/fr/applications/index.html) on the Cloudwatt website, choose the apps, press **DEPLOYER** and follow the simple steps... 2 minutes later, a green button appears... **ACCEDER**: you have your pfsense server!

## Enjoy

Once connected to the VPN on the stack you now have access to the administration interface via the URL **http://manager**. Access to the interface and the various applications is via **DNS** names. Indeed a **SkyDNS** container is launched at startup allowing you to benefit all the short names in place. You can access different web interfaces for applications by clicking **Go** or via URL request (ex: http://zabbix/).
Also we attached a volume to your stack in order to save all **data** containers of the toolbox , so you can go back in a new instance. The volume is mounted on the master instance in the directory `/dev/vdb`.

#### Interface Overview


Here is the home of the toolbox, each thumbnail representing an application ready to be launched. In order to be as scalable and flexible as possible, all applications of this toolbox are containers (Docker).

![accueil](img/accueil.png)

A menu is present in the top left of the page , it can move through the different sections of the toolbox , we'll detail them later .
* Apps: Application List
* Instances: list of visible instances of the toolbox
* Tasks : all ongoing or completed tasks
* Audit: list of actions performed
* My Instances> Console: access to the console Horizon
* My account> Cockpit access to my account

![menu](img/menu.png)

The **tasks** make the tracking of actions performed on the toolbox . It is reported in relative time.

![tasks](img/tasks.png)


All of these containers can be configured thanks to the **Settings** button ![settings](img/settings.png) on each thumbnail.

As you can see, we have separated them into different sections.
![params](img/params.png)

In the **Info** section you will find a presentation of the application with some useful links on the application.

![appresume](img/appresume.png)


 In the **Environments** section you can register here all the parameters to be used to configure the variables of the container to its launch environment.
 ![paramsenv](img/paramenv.png)

  In the **Parameters** section you can register here all the different application configuration settings.
  ![paramapp](img/paramapp.png)


To identify the applications running, we have set up a color code. An application will be started with a green halo.
![appstart](img/appstart.png)

### Add instances to my Toolbox

To add instances to the toolbox , 3 steps:

  * Attach your router instance of the toolbox
  * Run the script attachment
  * Start the desired services


**Attach the instance at the instance of router:**

~~~bash
$ neutron router-interface-add $Toolbox_ROUTER_ID $Instance_subnet_ID
~~~

You will find all the information by inspecting the stack of resources via the command next heat :

~~~bash
$ heat resource-list $stack_name
~~~

Once this is done you are now in the ability to add your instance to the toolbox to instrumentalize .

**Start the attachment script:**


Go to the **instance** menu and click the button ![bouton](img/plus.png) at the bottom right.

You must have 2 controls, and **Curl** **Wget** select *one of your choice* and copy into the instance to exploit.

![addinstance](img/addinstance.png)


Once the script is applied to the selected instance it should appear in the menu **instance** of your toolbox .

![appdisable](img/appdisable.png)


**For information** If you want to create an instance via the console Cloudwatt. You can do launch *the attachment script* before validation. However you have to attach your instance of the network toolbox.

![launchinstance](img/launchinstance.png)


**Start the required services on the instance :**

To help you maximum we created playbooks Ansible to automatically install and configure the agents for different applications.


To do this, simply click on the application you want to install on your machine. The playbook Ansible concerned will be automatically installed.
Once the application is installed, the application logo switch to color, allowing you to identify the applications installed on your instances.

![appenable](img/appenable.png)


It is possible for you to cancel pending on error spot in the **tasks** menu by clicking ![horloge](img/horloge.png) which will then show you this logo ![poubelle](img/poubelle.png).

We also implemented a **audit** section, so you can see all actions performed on each of your instances and export to Excel (.xlsx ). If you want to make a post-processing or keep this information for safety reasons via the button ![xlsx](img/xlsx.png).

![audit](img/audit.png)


Finally, in order to help you to the maximum, we integrated two links in the menu of the toolbox : **My instance** and **My Account**.
They are respectively used to access to your instances via the Horizon Cloudwatt console and access to the Cockpit interface to manage your account.


## Services

In this section, we will present the different services of this Toolbox.

### APT mirror
To meet this need we have chosen to use Aptly.
This is a **APT package manager**. It allows you to mirror a web APT directory to distribute it to all your machines into which they do not necessarily  access to internet via a Nginx server.

To go further, here are some helpful links :
* https://www.aptly.info/
* http://korben.info/aptly-loutil-ultime-pour-gerer-vos-depots-debian.html/


### Mirror ClamAV - Antivirus
This application is a Ngnix server. A **CRON** script will run every day to fetch the latest **virus** definition distributed by ClamAV and then the recovered packet will be exposed to your instances via Ngnix. Allowing you to have customers **ClamAV** up to date without access internet.

To go further, here are some helpful links :
* https://www.clamav.net/documents/private-local-mirrors
* https://github.com/vrtadmin/clamav-faq/blob/master/mirrors/MirrorHowto.md

### Log Management

We chose Graylog which is the product of the moment for log management , here is a short presentation :
Graylog is an open source log management platform capable of manipulating and presenting data from virtually any source. This container is the offer officially by Graylog teams.

  * The Graylog Web Interface is a powerful tool that allows anyone to manipulate the entirety of what Graylog has to offer through an intuitive and appealing web application.
  * At the heart of Graylog is it's own strong software. Graylog Server interacts with all other components using REST APIs so that each component of the system can be scaled without comprimising the integrity of the system as a whole.
  * Real-time search results when you want them and how you want them: Graylog is only able to provide this thanks to the tried and tested power of Elasticsearch. The Elasticsearch nodes behind the scenes give Graylog the speed that makes it a real pleasure to use.

Enjoying this impressive architecture and a large library of plugins, Graylog stands as a strong and versatile solution for log management.

To go further, here are some helpful links :
* https://www.graylog.org/
* http://docs.graylog.org/en/1.2/pages/getting_started.html#get-messages-in
* http://docs.graylog.org/en/1.3/pages/architecture.html
* https://www.elastic.co/products/elasticsearch
* https://docs.mongodb.org/manual/tutorial/install-mongodb-on-ubuntu/

###Mirror YUM
We have chosen to use Nexus.
Nexus is an application that can display any type of directory server via a Ngnix . Here our aim is to offer an application that can **expose a YUM repository** for all of your instances.

To go further, here are some helpful links :
* https://books.sonatype.com/nexus-book/reference/index.html
* https://books.sonatype.com/nexus-book/reference/yum-configuration.html

### Time Synchronisation

We have chosen to use NTP.
NTP container is used here so that all of your instances without access to the internet can be synchronized to the same time and access to **a server time**.

To go further, here are some helpful links :
  * http://www.pool.ntp.org/fr/

### Job Scheduler
We have chosen to use Rundeck.
The Rundeck application will allow you **to schedule and organize all jobs** that you want to deploy consistently on all of your holding via its web interface. In our case we wanted to give you the opportunity to set up a script to back up your servers as we saw in the *bundle* Duplicity (next version of the toolbox).

To go further, here are some helpful links :
* http://rundeck.org/
* http://blog.admin-linux.org/administration/rundeck-ordonnanceur-centralise-opensource-vient-de-sortir-sa-v2-0
* http://dev.cloudwatt.com/fr/blog/5-minutes-stacks-episode-vingt-trois-duplicity.html

### Monitoring
We have chosen to use Zabbix.
Zabbix application is free software **to monitor the status of various network services , servers and other network devices**; and producing dynamic graphics resource consumption.
Zabbix uses MySQL, PostgreSQL or Oracle to store data. According to the large number of machines and data to monitor the choice of SGBD greatly affects performance. Its web interface is written in PHP and provided a real-time view on the collected metrics.

To go further, here are some helpful links :
* http://www.zabbix.com/
* https://www.zabbix.com/documentation/3.0/start

## So watt ?

The goal of this tutorial is to accelerate your start. At this point **you** are the master of the stack.

You now have an SSH access point on your virtual machine through the floating-IP and your private keypair (default user name `core`).

* Get the OpenVPN configuration file on the instance of the toolbox
* Once connected to the VPN toolbox, you have access to the web interface via the url **http://manager**.


## And afterwards?

This article will acquaint you with this first version of the toolbox. It is available to all users Cloudwatt in Beta mode and therefore currently free.


The intention of the CAT ( Cloudwatt Automation Team) is to provide improvements on a monthly basis. In our roadmap, we expect among others:
* A French version
* Add the backup function
* HA Version
* An additional menu to contact Cloudwatt supporting teams

-----
Have fun. Hack in peace.

The CAT
