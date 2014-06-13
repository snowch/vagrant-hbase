package hbase;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.hbase.HBaseConfiguration;
import org.apache.hadoop.hbase.HColumnDescriptor;
import org.apache.hadoop.hbase.HTableDescriptor;
import org.apache.hadoop.hbase.client.HBaseAdmin;
import org.apache.hadoop.hbase.client.HTable;
import org.apache.hadoop.hbase.client.HTableInterface;
import org.apache.hadoop.hbase.client.Put;
import org.apache.hadoop.hbase.util.Bytes;

public class Main {

	public static void main(String[] args) throws Exception {
		
		Configuration myConf = HBaseConfiguration.create();	
		myConf.set("hbase.zookeeper.quorum",  "192.168.50.4");
		
		HBaseAdmin.checkHBaseAvailable(myConf);
		
		HBaseAdmin hbase = new HBaseAdmin(myConf);
		
		HTableDescriptor[] tables = hbase.listTables("users");
		
		if (tables.length == 0) {
			HTableDescriptor desc = new HTableDescriptor("users");
			HColumnDescriptor meta = new HColumnDescriptor("cf".getBytes());
			HColumnDescriptor prefix = new HColumnDescriptor("info".getBytes());
			desc.addFamily(meta);
			desc.addFamily(prefix);
			hbase.createTable(desc);
		}
		
		
		HTableInterface users = new HTable(myConf,  "users");
		
		Put p = new Put(Bytes.toBytes("snowch"));
		p.add(Bytes.toBytes("info"),
				Bytes.toBytes("name"),
				Bytes.toBytes("Chris Snow")
				);
		
		users.put(p);
		users.close();
	}

}
