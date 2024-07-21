bring ex;
bring cloud;
bring util;

pub class FlatFileSystem {
  db: ex.DynamodbTable;
  blobStore: cloud.Bucket;
  new() {
    this.db = new ex.DynamodbTable(
      attributeDefinitions: {
        "pk": "S",
      },
      hashKey: "pk",
      name: "filesystem",
    );   
    this.blobStore = new cloud.Bucket(); 
  }

  pub inflight createFolder(name: str){
    this.db.putItem(
      item: {
        pk: "dir:{name}",
        name: name
    });
  }
  
  pub inflight createFile(folder: str, name: str, content: str){
    let key = util.sha256(content);
    this.blobStore.put(key, content);
    this.db.putItem(
      item: {
        pk: "file:folder-{folder}:name-{name}",
        name: name,
        key: key
    });
  }

  // helper function
  inflight scan(prefix: str): Array<str> {
    let response = this.db.scan(
      filterExpression: "begins_with(pk, :prefix)",
      expressionAttributeValues: { 
        ":prefix": prefix 
      }
    );
    let result = MutArray<str>[];
    for j in response.items {
      result.push(j.get("name").asStr());
    }
    return result.copy();
  }

  pub inflight listFolders(): Array<str> {
    // TODO
    return this.scan("dir");
  }

  pub inflight listFiles(folder: str): Array<str> {
    // TODO

    return this.scan("file:folder-{folder}");
  }

  pub inflight getFile(folder: str, name: str): str {

    // TODO
    let response = this.db.getItem(
        key: {
            pk: "file:folder-{folder}:name-{name}"
        }
    );
    let key = response.item?.get("key")?.asStr() ?? "";
    return this.blobStore.get(key);

  }
  
}