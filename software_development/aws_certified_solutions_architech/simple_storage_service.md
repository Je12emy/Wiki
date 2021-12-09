# Simple Storage Service

Simple Storage Service, also known as S3, is an object-based **storage** service, in here we don't have to worry about file systems nor disk space for storing our files.

## What is Object Storage?

> Object storage is a data storage architecture which manages data as objects.

Other storage architectures are:

* File Systems which manage data as files in a hierarchy.
* Block Storage which manage data as blocks within sectors as tracks.

The biggest benefit provided by S3 is **unlimited storage**, where we don't need to worry about the infrastructure to support our storage needs.

In here we will find two key components:

* S3 Object: These contain our data, they are similar to regular files, and they contain the following properties.
    * Key: The name of the object.
    * Value: The data itself.
    * Version ID: Used for versioning our object, it is only used when versioning is enabled.
    * Metadata: Any additional information attached to the object.
* S3 Bucket: Buckets hold objects, you could consider them as top level directories, which may hold other subdirectories which may also hold objects. S3 is a universal namespace, so **buckets need a universal name**.

**Important:** An object may store 0 up to 5 Terabytes of data.

## Storage Classes

Storage classes could be considered as a storage tier for our buckets, this allows us to save up costs based on our storage needs.

1. Standard (default): 
    * Fast with a 99.99% availability
    * [11 9's durability](https://cloud.google.com/blog/products/storage-data-transfer/understanding-cloud-storage-11-9s-durability-target)
    * Data is replicated across 3 _availability zones_
* Intelligent Tiering.
    * Uses machine learning to determine an appropriate class based on our object's usage. 
* Standard Infrequently Accessed (IA)
    * Still fast.
    * Cheaper **if you access files less than a month**.
    * An additional retrieval free is applied when we access our data.
    * Cost is 50% cheaper than the standard class.
* One Zone IA
    * Still fast.
    * Object is only existent on a single availability zone, which means than durability is lower.
    * Availability is 99.5%.
    * A retrieval fee is applied.
    * 20% cheaper than Standard Infrequently Accessed (IA)
* Glacier
    * Used for **long term cold storage**
    * Retrieval of data could take several minutes, up to an hour.
    * A retrieval fee is also applied.
    * This is a very low-cost solution.
    * Is promoted as its own AWS service, but it is part of S3.
* Glacier Deep Archive: 
    * Similar to Glacier but retrieval could take up to **12 hours**.
    * The cheapest option.

By comparing all the available classes we end up with the following chart.

| Feature                         | Standard | Intelligent Tiering | Standard IA | One-Zone IA | Glacier       | Glacier Deep Archive |
| ------------------------------- | -------: | -----------------:  | ----------: | ----------: | ------------: | -------------------: |
| Durability                      | 11 9’s   | 11 9’s              | 11 9’s      | 11 9’s      | 11 9’s        | 11 9’s               |
| Availability                    | 99.99%   | 99.99%              | 99.90%      | 99.50%      | N/A           | N/A                  |
| Availability SLA                | 99.99%   | 99.00%              | 99.00%      | 99.00%      | N/A           | N/A                  |
| AZ's                            | > 3      | > 3                 | > 3         | 1           | > 3           | > 3                  |
| Min. Capacity charge per object | N/A      | N/A                 | 128 KB      | 128 KB      | 40 KB         | 40 KB                |
| Min. Storage duration charge    | N/A      | 30 Days             | 30 Days     | 30 Days     | 90 days       | 180 days             |
| Retrieval fee                   | N/A      | N/A                 | Per GB      | Per GB      | Per GB        | Per GB               |
| First byte latency              | ms       | ms                  | ms          | ms          | mins to hours | hours                |

Key takeaways:

* One one-zone IA there should be lowered durability since there is a single point of failure, this value could actually refer to the infrastructure where our data is stored.
* We won't put an availability % on Glacier since retrieving content is so slow.
* First byte latency refers to how fast we can retrieve data from S3.

S3 Guarantees:

* The platform is build with 99.99% availability.
* Amazon guarantees 99.9 availability.
* Amazon guarantees 11'9s of durability.

## S3 Security

When we create a new bucket, they are all **private by default** and AWS really promotes not exposing buckets. Logging per request can be enabled in order to know which objects are being accessed and uploaded into our bucket, though logs are stored in a separate bucket. In S3 there are two security solutions:

* Access Control Lists: This is a legacy feature, though it's not deprecated, this is a very simple way for granting access to an object say public access or just read and write permissions.
* Bucket Policies: This is a more complex way of setting access policies since we need to write these policies into a JSON file.

### S3 Encryption

When we upload files to S3, we are using **SSL/TLS** by default, this means we have encryption for traffic between our local host and S3, for **Server Side Encryption** or SSE (this encrypts the data itself) there are a few options.

* SSE-AES: A 256 byte in length to be used in encryption, this is completely handled by S3.
* SSE-KMS or Key Managed: Keys are encrypted with another key, these keys can be managed by AWS or by us.
* SSE-C or Customer Provided: We provide the keys ourselves.

We can also encrypt our own files before uploading them to AWS, which is known as **Client Side Encryption**.


## S3 Data Consistency

When we put or write data to S3, which happens when we create new objects, the consistency is going to be different when we overwrite or delete objects.

### New Objects (PUTS)

When we send new data to S3 as a new object it's going to be *Read After Write* Consistency, this means that when upload a new S3 object we are immediately able to read the data, and it's going to be consistent.

### Overwrite (PUTS) or Delete Objects (DELETES)

When we overwrite or delete an existing object we deal with *Eventual Consistency*, which means that it takes time for S3 to replicate this changes to all AZ's, in this case, if we were to read the data after uploading it, S3 may return an old copy. We generally need to wait a few seconds before reading the new data.

## Cross Region Replication or CRR

When this feature is enable, any object that is uploaded will be **automatically replicated** to another region, this provides higher durability and disaster recovery for objects. 

![S3 CRR](https://i.imgur.com/Khd7xLV.png)

*Note:* It is also possible to copy an object into another S3 bucket in a separate account.

To enable CRR you must enable versioned on both the source and the destination buckets.

## Versioning

On S3 we can enable versioning on a bucket, this allows us to version our objects in order to prevent data loss and version tracking.

* Store all versions of an object in S3.
* Once enabled it cannot be disabled, only suspended.
* Fully integrates with S3's lifecycle rules.

![S3 Versioning](https://i.imgur.com/gVjullY.png)

*Note:* We are able to retrieve a specific object version.

## Lifecycle Management

This feature automates to process of moving objects between storage classes or deleting them completely. A simple use case would be:

* 7 days after uploading an object to S3 update an object class to the Glacier storage class, since we are unlikely to continue using it, this would save up on costs.
* 365 days after uploading an object to S3, remove it, since it's no longer needed.
 
![S3 Sample Lifecycle Rule](https://i.imgur.com/gVjullY.png)

## Transfer Acceleration

This feature provides us **fast and secure** transfer of files over long distances between end users and an S3 bucket, in here instead of uploading an object into an S3 bucket, you upload your data into a `distinct URL` for an **Edge Location** (a data center that is as close as possible). Once the data is uploaded the Edge Location, it is then forwarded through a specially optimized network (Amazon's backbone network)

![S3 Transfer Acceleration](https://i.imgur.com/rq2fw3i.png)

## Presigned URLs

This is a key feature when building web applications, this feature allows us to build a URL to provide temporary access to an object for either upload or download. These are commonly used to provide access to private objects, they can only be generated by the `AWS CLI` or the `AWS SDK`.

![S3 Presigned URL Example](https://i.imgur.com/79G7b5P.png)

## MFA Delete

To prevent other users from deleting our objects, we can enable MFA Delete which ensures users won't delete objects from a bucket unless they provide their MFA code. This feature may only be enabled if:

1. The AWS CLI is used to enable MFA.
2. The bucket must have versioning turned on.

```bash
aws s3api put-bucket-versioning \
    --bucket bucketname \
    --versioning-configuration Status=Enabled,MDADelete=Enabled \
    --mda "your-mda-serial-number mfa-code" \
```

*Note:* Only the bucket owner logged in as a Root user can delete objects from the bucket.

![S3 MFA](https://i.imgur.com/ygGpql3.png)

## Hands-On

### Creating a S3 Bucket

Most AWS services need us to specify a region, this is not the case for S3 and we may use the "Global" region in the top right corner.

![S3 Region Selection](https://i.imgur.com/hxN1Jjo.png)

To create our first bucket, click on "Create Bucket" and provide a bucket name, just as registering a domain name we can't use certain characters for our bucket's name, finally select a region.

![S3 Bucket Creation](https://i.imgur.com/UyFdrgk.png)

Deleting this bucket is a simple as selecting it and clicking "Delete Bucket"

![S3 Deleting a Bucket](https://i.imgur.com/3srSt2z.png)


### Uploading to a Bucket

Uploading files to our bucket can be done by simply dragging them into our bucket.

![S3 Uploading File to S3](https://i.imgur.com/c6bLNY6.png)

After uploading a file we may click it and view its details.

![S3 Object Details](https://i.imgur.com/oR7RXjI.png)

In here we will find we will find the `Object URL` which is the link to this object on the public internet, notice how our bucket's name is being used in this URL which is why these bucket names should be unique, if we were to click on this link we won't be able to view this image since bucket are **private by default**. 

### Making a Bucket Public

Visit the bucket and select the properties tab, scroll down to `Block public access`, in here we are able to edit a bucket's public access
