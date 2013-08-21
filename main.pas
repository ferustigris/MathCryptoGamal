unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Mask, bnumber, Menus;

type
  TForm1 = class(TForm)
    mMsg: TMemo;
    sbbar: TStatusBar;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    meKeyLength: TEdit;
    bProgress: TProgressBar;
    log: TMemo;
    mm: TMainMenu;
    N1: TMenuItem;
    nGen: TMenuItem;
    nClose: TMenuItem;
    nCheck: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure progress();
    procedure nCloseClick(Sender: TObject);
    procedure nGenClick(Sender: TObject);
    procedure nCheckClick(Sender: TObject);
  private
    { Private declarations }
    p,//simple
    g,//g^phi(p)=1 mod p
    r,//r=g^k mod(p)
    s,//m = xr+rs mod p
    y//y=g^x mod(p)
   : TBNumber;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
uses umd5, unod;
{$R *.dfm}
procedure TForm1.progress();
begin
  if(bProgress.Position = bProgress.Max)then
    bProgress.Position := 0
  else
    bProgress.Position := bProgress.Position + 1;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if(not test()) then ShowMessage('Ошибка при операциях с БЧ!');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  g := nil;
  p := nil;
  r := nil;
  y := nil;
  s := nil;
end;

procedure TForm1.nCloseClick(Sender: TObject);
begin
  close();
end;

procedure TForm1.nGenClick(Sender: TObject);
var
  n,//key length
  i,
  nk//part of n
   : integer;
  m, m_mod, m_div,
  e0, e1, e2, p_minus1,//1, 2
  tmp, rate,
  half,//p/2
  k,//simple with p
  xr,//x*r
  x//simple with p
   : TBNumber;
  h : String;
  simple: boolean;//is simple?
begin
  n := strToInt(meKeyLength.Text);
  half := nil;
  m_mod := nil;
  m_div := nil;
  tmp := nil;
  k := nil;
  x := nil;
  FreeAndNil(s);
  FreeAndNil(r);
  FreeAndNil(y);
  FreeAndNil(g);
  FreeAndNil(p);
  //выбирается простое p
  sbBar.Panels[0].Text := 'выбирается простое p';
  e0 := TBNumber.create('0');
  e1 := TBNumber.create('1');
  e2 := TBNumber.create('2');
  //генерируем простое число, тупо, но для генерации случайного числа много усилий нужно)
  repeat
    randomize;
    h := '';
    for i := 0 to n-1 do
      h := h + IntToStr(random(10));
    if(h[1] = '0')then
      h[1] := '1';
    FreeAndNil(p);
    p := TBNumber.create(h);
    tmp := TBNumber.create('2');
    //простое?
    p.sub(e2, half, m_mod);
    FreeAndNil(m_mod);
    simple := true;
    while(tmp.cmp(half) <= 0) do
    begin
      p.sub(tmp, m_mod, m_div);
      freeAndNil(m_mod);
      if(m_div.cmp(e0) = 0)then
      begin
        freeAndNil(m_div);
        simple := false;
        break;
      end;
      freeAndNil(m_div);
      progress();
      application.ProcessMessages;
      tmp.sum(e1);
    end;
    FreeAndNil(tmp);
  until(simple);
  log.Lines.add('p=' + p.print);
  sbBar.Panels[0].Text := 'вычисляем дайджест M: m = h(M):';
  p_minus1 := TBNumber.create(p);
  p_minus1.sum(TBNumber.create('-1'));
  h := md5(mMsg.Lines.GetText());//вычисляем дайджест M: m = h(M):
  //log.Lines.add('Дайджест:' + h);
  m := TBNumber.create(h, 16);
  //if(m.cmp(p_minus1) >= 0)then raise Exception.Create('Дайджест > p!');
  m.sub(p_minus1, m_div, m_mod);
  freeAndNil(m);
  m := TBNumber.create(m_mod);
  log.Lines.add('m=' + m.print);
  freeAndNil(m_div);
  freeAndNil(m_mod);
  //выбирается 1 < k < p-1 взаимно простое с p-1
  sbBar.Panels[0].Text := 'выбирается простое 1 < k < p-1';
  repeat
    repeat
      randomize;
      h := '';
      if(n > 1)then
        nk := 0
      else
        nk := n;
      while(nk = 0)do
        nk := random(n);
      for i := 1 to nk do
        h := h + IntToStr(random(10));
      if(h[1] = '0')then
        h[1] := '1';
      FreeAndNil(k);
      k := TBNumber.create(h);
    until(p.cmp(k) > 0);
    progress();
    application.ProcessMessages;
    //взаимно ппростое с p-1?
  until(k.cmp(e1) <> 0)and(nod(p_minus1,k).cmp(e1) = 0);
  log.Lines.add('k=' + k.print);
  //выбирается 1 < g < p взаимно простое с p
  sbBar.Panels[0].Text := 'выбирается 1 < g < p, первообразный корень по модулю p';
  repeat
    repeat
      FreeAndNil(tmp);
      h := '';
      if(n > 1)then
        nk := 0
      else
        nk := n;
      while(nk = 0)do
        nk := random(n+1);
      repeat
        randomize;
        h := '';
        for i := 1 to nk do
          h := h + IntToStr(random(10));
      until(h[1] <> '0');
      FreeAndNil(g);
      g := TBNumber.create(h);
      progress();
      application.ProcessMessages;
      FreeAndNil(tmp);
      FreeAndNil(rate);
      rate := TBNumber.create(e1);
      g.sub(p, m_div, m_mod);
      FreeAndNil(m_div);
      m_div := TBNumber.create(m_mod);
      tmp := phi(g);
      while(rate.cmp(tmp) <= 0)do
      begin
        m_mod.mult(m_div);
        rate.sum(e1);
      end;
      FreeAndNil(m_div);
      FreeAndNil(tmp);
      m_mod.sub(p, m_div, tmp);
    until(p.cmp(g) > 0)and(tmp.cmp(e1) <> 1);
    FreeAndNil(tmp);
    //взаимно ппростое с p?
  until(nod(p,g).cmp(e1) = 0);
  log.Lines.add('g=' + g.print);
  //вычисляется r=g^k mod(p)
  sbBar.Panels[0].Text := 'вычисляется r=g^k mod(p)';
  FreeAndNil(tmp);
  FreeAndNil(r);
  FreeAndNil(m_div);
  tmp := TBNumber.create(e1);
  g.sub(p, m_div, r);
  FreeAndNil(m_div);
  m_div := TBNumber.create(r);
  while(tmp.cmp(k) < 0)do
  begin
    r.mult(m_div);
    tmp.sum(e1);
    progress();
    application.ProcessMessages;
  end;
  FreeAndNil(tmp);
  tmp := TBNumber.create(r);
  FreeAndNil(r);
  FreeAndNil(m_div);
  tmp.sub(p, m_div, r);
  FreeAndNil(tmp);
  FreeAndNil(m_div);
  log.Lines.add('r=' + r.print);
  //выираем случайное x < p
  sbBar.Panels[0].Text := 'выбирается x < p';
  repeat
    randomize;
    h := '';
      if(n > 1)then
        nk := 0
      else
        nk := n;
    while(nk = 0)do
      nk := random(n);
    for i := 1 to nk do
      h := h + IntToStr(random(10));
    if(h[1] = '0')then
      h[1] := '1';
    FreeAndNil(x);
    x := TBNumber.create(h);
    progress();
    application.ProcessMessages;
  until(p.cmp(x) >= 0);
  log.Lines.add('x=' + x.print);
  //m=xr+ks mod p-1
  sbBar.Panels[0].Text := 'Находим s: m=xr+ks mod p-1';
  xr := TBNumber.create(x);
  xr.mult(r);
  s := TBNumber.create(e0);
  repeat
    s.sum(e1);
    tmp := TBNumber.create(k);
    tmp.mult(s);
    tmp.sum(xr);
    FreeAndNil(m_div);
    FreeAndNil(m_mod);
    tmp.sub(p_minus1, m_div, m_mod);
    progress();
    application.ProcessMessages;
  until(m.cmp(m_mod) = 0);
  log.Lines.add('s=' + s.print);
  FreeAndNil(m_div);
  FreeAndNil(m_mod);
  //y=g^x mod p
  sbBar.Panels[0].Text := 'вычисляется y=g^x mod(p)';
  FreeAndNil(tmp);
  FreeAndNil(y);
  FreeAndNil(m_div);
  tmp := TBNumber.create(e1);
  g.sub(p, m_div, y);
  FreeAndNil(m_div);
  m_div := TBNumber.create(y);
  while(tmp.cmp(x) < 0)do
  begin
    y.mult(m_div);
    tmp.sum(e1);
    progress();
    application.ProcessMessages;
  end;
  FreeAndNil(tmp);
  tmp := TBNumber.create(y);
  FreeAndNil(y);
  FreeAndNil(m_div);
  tmp.sub(p, m_div, y);
  FreeAndNil(tmp);
  FreeAndNil(m_div);
  log.lines.add('y=' + y.print);
  FreeAndNil(e0);
  FreeAndNil(e1);
  FreeAndNil(e2);
  FreeAndNil(p_minus1);
  FreeAndNil(x);
  FreeAndNil(m_div);
  FreeAndNil(m_mod);
  FreeAndNil(k);
  FreeAndNil(tmp);
  sbBar.Panels[0].Text := 'Завершено';
end;

procedure TForm1.nCheckClick(Sender: TObject);
var
  m, m_div,
  e0, e1,
  tmp, p_minus1,
   l1, l2, gm
   : TBNumber;
  h : String;
begin
  log.Lines.add('Проверка подлиности...');
  tmp := nil;
  l1 := nil;
  l2 := nil;
  gm := nil;
  m_div := nil;
  if(s = nil)or
    (r = nil)or(y = nil)or(g = nil)or(p = nil)then
    raise Exception.Create('Gen first!');
  sbBar.Panels[0].Text := 'вычисляем дайджест M: m = h(M):';
  p_minus1 := TBNumber.create(p);
  p_minus1.sum(TBNumber.create('-1'));
  h := md5(mMsg.Lines.GetText());//вычисляем дайджест M: m = h(M):
  //log.Lines.add('Дайджест:' + h);
  m := TBNumber.create(h, 16);
  //if(m.cmp(p_minus1) >= 0)then raise Exception.Create('Дайджест > p!');
  m.sub(p_minus1, m_div, l1);
  freeAndNil(m);
  m := TBNumber.create(l1);
  log.Lines.add('m=' + m.print);
  freeAndNil(m_div);
  freeAndNil(l1);
  e0 := TBNumber.create('0');
  e1 := TBNumber.create('1');
  //y^r
  FreeAndNil(tmp);
  FreeAndNil(l1);
  FreeAndNil(m_div);
  tmp := TBNumber.create(e1);
  y.sub(p, m_div, l1);
  FreeAndNil(m_div);
  m_div := TBNumber.create(l1);
  while(tmp.cmp(r) < 0)do
  begin
    l1.mult(m_div);
    tmp.sum(e1);
    progress();
    application.ProcessMessages;
  end;
  FreeAndNil(tmp);
  tmp := TBNumber.create(l1);
  FreeAndNil(l1);
  FreeAndNil(m_div);
  tmp.sub(p, m_div, l1);
  FreeAndNil(tmp);
  FreeAndNil(m_div);
  log.Lines.Add('y^r=' + l1.print);
  //r^s
  FreeAndNil(tmp);
  FreeAndNil(l2);
  FreeAndNil(m_div);
  tmp := TBNumber.create(e1);
  r.sub(p, m_div, l2);
  FreeAndNil(m_div);
  m_div := TBNumber.create(l2);
  while(tmp.cmp(s) < 0)do
  begin
    l2.mult(m_div);
    tmp.sum(e1);
    progress();
    application.ProcessMessages;
  end;
  FreeAndNil(tmp);
  tmp := TBNumber.create(l2);
  FreeAndNil(l2);
  FreeAndNil(m_div);
  tmp.sub(p, m_div, l2);
  FreeAndNil(tmp);
  FreeAndNil(m_div);
  log.Lines.Add('r^s=' + l2.print);
  //r^s*y^r
  l1.mult(l2);
  tmp := TBNumber.create(l1);
  FreeAndNil(l2);
  FreeAndNil(l1);
  FreeAndNil(m_div);
  tmp.sub(p, m_div, l1);
  FreeAndNil(tmp);
  FreeAndNil(m_div);
  log.Lines.Add('r^s*y^r=' + l1.print);
  //g^m
  FreeAndNil(tmp);
  FreeAndNil(gm);
  FreeAndNil(m_div);
  tmp := TBNumber.create(e1);
  g.sub(p, m_div, gm);
  FreeAndNil(m_div);
  m_div := TBNumber.create(gm);
  while(tmp.cmp(m) < 0)do
  begin
    gm.mult(m_div);
    tmp.sum(e1);
    progress();
    application.ProcessMessages;
  end;
  FreeAndNil(tmp);
  tmp := TBNumber.create(gm);
  FreeAndNil(gm);
  FreeAndNil(m_div);
  tmp.sub(p, m_div, gm);
  FreeAndNil(tmp);
  FreeAndNil(m_div);
  FreeAndNil(p_minus1);
  log.Lines.Add('g^m=' + gm.print);
  application.ProcessMessages;
  if(gm.cmp(l1) = 0)then
  begin
    showMessage('Проверка прошла успешно!');
    log.Lines.Add('Проверка прошла успешно!')
  end
  else
  begin
    showMessage('Проверка прошла не успешно!');
    log.Lines.Add('Проверка прошла не успешно!')
  end;
  sbBar.Panels[0].Text := 'Завершено';
end;

end.
