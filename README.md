## My Project

UNDER CONSTRUCTION. please check back later

Some instructions to be fleshed out:
- Download copy of ontop_main.yaml
- Run CloudFormation stack from ontop_main.yaml. Stack creates: Neptune cluster plus notebook, ECS Cluster, Glue DB and table, Cloud9 IDE, S3 bucket, and some roles
- Open notebook and follow steps to copy S3, the bulk-load to Neptune
- Open Cloud9 IDE and: do the following
	- Clone GIT repo
	- chmod +x on the .sh files
	- run build.sh passing STACKNAME as arg
	- run deploy.sh passing STACKNAME and ECSSTACKNAME as args. Check the CFN console to see the stack runs successfully

```
aws s3 cp --recursive  s3://$PUB_BUCKET/$ROOT_DIR_NOSLASH/lake s3://$DATA_BUCKET/lake/climate
Then run the crawler from console


git clone https://github.com/aws-samples/amazon-neptune-graph-virtualization.git
cd amazon-neptune-graph-virtualization/scripts/
chmod +x *.sh
./build.sh sing1
./deploy.sh sing1 ecs1
```

Current limitations:
- Not all data is in source bucket
- Glue table not 100 percent correct


Be sure to:

* Change the title in this README
* Edit your repository description on GitHub

## Security

See [CONTRIBUTING](CONTRIBUTING.md#security-issue-notifications) for more information.

## License

This library is licensed under the MIT-0 License. See the LICENSE file.

