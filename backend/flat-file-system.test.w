bring expect;
bring "./flat-file-system.w" as f;

let fs = new f.FlatFileSystem();

test "get and create folders" {
  expect.equal([], fs.listFolders());
  fs.createFolder("a");
  expect.equal(["a"], fs.listFolders());
}

test "get and create file" {
  fs.createFolder("d1");
  fs.createFile("d1", "f1", "Hello Wing");
  expect.equal(["f1"], fs.listFiles("d1"));
  expect.equal("Hello Wing", fs.getFile("d1", "f1"));
}