## My Project

UNDER CONSTRUCTION. please check back later

Some instructions to be fleshed out:
- Download copy of ontop_main.yaml
- Run CloudFormation stack from ontop_main.yaml. Stack creates: Neptune cluster plus notebook, ECS Cluster, Glue DB and crawler, Cloud9 IDE, S3 bucket, and some roles
- Open Cloud9 IDE, open a terminal and run the following:

```
# get the code
git clone https://github.com/aws-samples/amazon-neptune-graph-virtualization.git

# make scripts executable
cd amazon-neptune-graph-virtualization/scripts/
chmod +x *.sh

# Copy data files to your bucket. This might take several minutes.
./s3cp.sh <yourstackname>

# Keep shell open. Will come back to this.
```

- Next, in a separate tab in your browser, go to the Glue console. Under Crawlers, check you have a crawler called ClimateCrawler. Run the crawler. Wait for the crawler to complete.

- Still in Glue console, check Tables under Data Catalog. There should be a table called climate. Confirm.

- In a separate tab in your browser, go to the Athena console. Go to the Query Editor. Under Settings, click Manage and set the location of the query result to the data bucket created by CFN.

- Still in Athena console, preview the climate table.

- Return to the terminal in the Cloud9 IDE. Build the
```

./build.sh <yourstackname>
./deploy.sh <yourstackname> ecs1
```

- In a separate tab in your browser, go to the ECS console. Find the running task for the ontop-lake table. Get its private IP address and copy it.

- In a separate tab in your browser, go to the SageMaker console. Open Jupyter. In Jupyter, open climate-data-queryes.ipynb and follow the steps.

Be sure to:

* Change the title in this README
* Edit your repository description on GitHub

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

