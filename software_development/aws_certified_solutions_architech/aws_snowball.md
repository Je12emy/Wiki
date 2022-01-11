# AWS Snowball

This is a **petabyte-scale** data transfer service, in here you move data into AWS via a physical briefcase computer. In case we want to move ALOT of data into AWS in the cheapest way posible and as soon as posible this is the ideal solution instead of doing this for months over the internet.

* It costs thousands of dollars to transfer 100 TB ober high speed internet, with snowball this is reduced by 1/5 th.
* It can take up to 100 days to transfer 100 TB of data, snowball can reduce this by less than a week.

## Features and Limitations

* Includes a E-Ink display for displaying shipping information.
* Tamper and weather proof.
* Data is encrypted end-to-end (256-bit encryption)
* Uses a Trusted Platform Module or TMP, this is a specialized chip for hardware authentication.
* For security purposes, data transfers must be completed within 90 days of the snowball being prepared.
* A snowball may import or export from S3.

There are two sizes for Snowball:

* 50 TB with 42 TB of usable space.
* 80 TB with 72 TB of usable space.

## Snowball Edge

This is yet another solution for transfering **petabyte-scale** via a physical briefcase with even more storage and on-site compute capabilites. This solutions is very similar to snowball but with more storage and local procesing.

### Features and Limitations

* Includes an LCD for displaying shipping information and other functionalities.
* Can undertake local procesing and edge-computing workloads
* Can be used in a cluster in groups of 5 to 10 devices.

These last two mean we can turn these devices into a mini data center if we wanted to, and there are 3 device configurations.

* Storage optimized (24 vCPUs)
* Compute optimized (54 vCPUs)
* GPU optimized (54 vCPUs)

There are two sizes.

* 100 TB with 83 TB of usable space.
* 100 TB with 45 TB of usable space.

## Snowmobile

This is a 13 meter shipping container, pulled by a semi-trailer, it can transfter up to 100 PB per vehicle. In here the AWS staff will help you connect your network to the snowmobile and when data is transfered, they will drive back to AWS to import the data.

### Features

* GPS tracking.
* Alarm monitoring.
* 24/7 video surveilance.
* An escord security vehicle while in transit (optional).
