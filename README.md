#[Simple Meteor App for Document Sharing]
Implemetation Steps
1.First, let’s install Meteor. If you’re on Mac or Linux, simply open a Terminal window and type:

	curl https://install.meteor.com | /bin/sh
2. Creating a Meteor app is pretty easy. Once you’ve installed Meteor, all you need to do is go back to the Terminal and type this:

	meteor create docshare-tutorial
3. You’ll then be able to run your brand new app locally with this:
	
	cd docshare-tutorial
	meteor docshare-tutorial
4. Add packages nedded,Here i use smart coffeescript,backbone,accounts-password,
	accounts-ui.The accounts-password,accounts-ui are used for implement registation and login facility with username,email and password.
	To add packages Open up a new Terminal window (since your app is already running in the first one) and enter:

	mrt add accounts-ui
	mrt add accounts-password

5. In this project use smart collection,which is now retired & Meteor’s Collection 		implementation has fixes for most of the performance bottlenecks.
	To implement smart collection follow below steps

	mrt add smart-collections
6. Smart Collection is now retired & Meteor’s Collection implementation has fixes 	for most of the performance bottlenecks. It is also using the MongoDB oplog just 	like Smart Collections.
	For the above , 
		* You need to configure MongoDB for an active oplog
		* You need to use Smart Collections in your app

	Configure MongoDB
		* Now you need to use a separate MongoDB server
		* Start it with mongod --replSet meteor
		* Start a mongo shell and configure mongo as follows
		Apply these commands
			var config = {_id: "meteor", members: [{_id: 0, host: "127.0.0.1:27017"}]}
			rs.initiate(config)
	Configure App
		* Use Smart Collections instead of Standard Collections
		* Start each Meteor instance with "OPLOG_URL" and the "MONGO_URL"
		Apply these commands
			export MONGO_URL=mongodb://localhost:27017/appdb
			export OPLOG_URL=mongodb://localhost:27017/local
			meteor
			
What is MongoDB Oplog
	MongoDB oplog is the heart of MongoDB’s replication engine (replicaSets). Oplog contains a log of all the write operations occurring in Mongo. In MongoDB replication, secondaries listen to master’s oplog and apply changes accordingly.