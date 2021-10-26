
@import 'fred.cds';
.foo { color: red; left: 20px; top: 20px; width: 100px; height:200px }
.class {isStored: true; package: home;}
.class [isStored=true] to .table {
    name : '${name|lc|ns}';
    parent : 'ddl/${package}';
    created : now();
    blah : lowercase(name)
}
.class [isStored=true] > .attribute to .column {
    name : '${name||lc|ns}';
    parent : '.table #${class.name|lc|ns}';
}