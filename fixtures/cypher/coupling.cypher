create (_1522:`Class` {`name`:"EfferentCoupling"})
create (_1523:`Class` {`name`:"This"})
create (_1524:`Method` {`file`:"fixtures/ruby/efferent_coupling.rb", `line_number`:5, `name`:"lots_of_coupling", `type`:"InstanceMethod"})
create (_1525:`CallSite` {`file`:"fixtures/ruby/efferent_coupling.rb", `line_number`:6})
create (_1526:`Method` {`file`:"/Users/markburns/code/delfos/fixtures/ruby/this.rb", `line_number`:3, `name`:"send_message", `type`:"ClassMethod"})
create (_1527:`CallStack` {`number`:1})
create (_1528:`Class` {`name`:"That"})
create (_1529:`CallSite` {`file`:"fixtures/ruby/efferent_coupling.rb", `line_number`:7})
create (_1530:`Method` {`file`:"/Users/markburns/code/delfos/fixtures/ruby/this.rb", `line_number`:3, `name`:"send_message", `type`:"ClassMethod"})
create (_1531:`CallStack` {`number`:2})
create (_1532:`Class` {`name`:"SomeOther"})
create (_1533:`CallSite` {`file`:"fixtures/ruby/efferent_coupling.rb", `line_number`:8})
create (_1534:`Method` {`file`:"/Users/markburns/code/delfos/fixtures/ruby/this.rb", `line_number`:3, `name`:"send_message", `type`:"ClassMethod"})
create (_1535:`CallStack` {`number`:3})
create (_1536:`CallSite` {`file`:"fixtures/ruby/efferent_coupling.rb", `line_number`:9})
create (_1537:`CallStack` {`number`:4})
create (_1538:`CallSite` {`file`:"fixtures/ruby/efferent_coupling.rb", `line_number`:10})
create (_1539:`CallStack` {`number`:5})
create (_1540:`Class` {`name`:"SoMuchCoupling"})
create (_1541:`CallSite` {`file`:"fixtures/ruby/efferent_coupling.rb", `line_number`:11})
create (_1542:`Method` {`file`:"/Users/markburns/code/delfos/fixtures/ruby/this.rb", `line_number`:13, `name`:"found_in_here", `type`:"ClassMethod"})
create (_1543:`CallStack` {`number`:6})
create (_1544:`Class` {`name`:"HereIsSomeMore"})
create (_1545:`CallSite` {`file`:"fixtures/ruby/efferent_coupling.rb", `line_number`:12})
create (_1546:`Method` {`file`:"/Users/markburns/code/delfos/fixtures/ruby/this.rb", `line_number`:17, `name`:"for_good_measure", `type`:"ClassMethod"})
create (_1547:`CallStack` {`number`:7})
create _1522-[:`OWNS`]->_1524
create _1523-[:`OWNS`]->_1526
create _1524-[:`CONTAINS`]->_1545
create _1524-[:`CONTAINS`]->_1541
create _1524-[:`CONTAINS`]->_1538
create _1524-[:`CONTAINS`]->_1536
create _1524-[:`CONTAINS`]->_1533
create _1524-[:`CONTAINS`]->_1529
create _1524-[:`CONTAINS`]->_1525
create _1525-[:`CALLS`]->_1526
create _1527-[:`STEP` {`number`:1}]->_1525
create _1528-[:`OWNS`]->_1530
create _1529-[:`CALLS`]->_1530
create _1531-[:`STEP` {`number`:1}]->_1529
create _1532-[:`OWNS`]->_1534
create _1533-[:`CALLS`]->_1534
create _1535-[:`STEP` {`number`:1}]->_1533
create _1536-[:`CALLS`]->_1534
create _1537-[:`STEP` {`number`:1}]->_1536
create _1538-[:`CALLS`]->_1534
create _1539-[:`STEP` {`number`:1}]->_1538
create _1540-[:`OWNS`]->_1542
create _1541-[:`CALLS`]->_1542
create _1543-[:`STEP` {`number`:1}]->_1541
create _1544-[:`OWNS`]->_1546
create _1545-[:`CALLS`]->_1546
create _1547-[:`STEP` {`number`:1}]->_1545
