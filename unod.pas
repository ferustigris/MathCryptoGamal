//алгоритм Евклида
unit unod;
interface
uses bnumber, sysUtils;
function nod(a, b: TBNumber) : TBnumber;
function phi(a: TBNumber) : TBnumber;
implementation
//find NOD(a,b) and return it
function nod(a, b: TBNumber) : TBnumber;
var
  r1,r2,m,q :TBNumber;
begin
  if(a.cmp(b) > 0)then
  begin
    r1 := TBNumber.create(a);
    r2 := TBNumber.create(b);
  end
  else
  if(a.cmp(b) < 0)then
  begin
    r1 := TBNumber.create(b);
    r2 := TBNumber.create(a);
  end
  else
  begin
    result := TBNumber.create(a);
    exit;
  end;
  m := nil;
  q := nil;
  while(r2.cmp(TBNumber.create('0')) <> 0)do
  begin
    r1.sub(r2, m, q);
    freeAndNil(r1);
    r1 := TBNumber.create(r2);
    freeAndNil(r2);
    r2 := TBNumber.create(q);
    freeAndNil(m);
    freeAndNil(q);
  end;
  result := TBNumber.create(r1);
  freeAndNil(r1);
  freeAndNil(r2);
end;
//Euler func
function phi(a: TBNumber) : TBnumber;
var
  m, e1 :TBNumber;
begin
  m := nil;
  e1 := nil;
  e1 := TBNumber.create('1');
  m := TBNumber.create(e1);
  result := TBNumber.create('0');
  while(m.cmp(a) < 0)do
  begin
    if(nod(a, m).cmp(e1) = 0)then
      result.sum(e1);
    m.sum(e1);
  end;
  freeAndNil(m);
  freeAndNil(e1);
end;

end.
 