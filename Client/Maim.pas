unit Maim;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, IdBaseComponent, IdComponent, System.Permissions,
  {$IFDEF ANDROID}
  	AndroidApi.Helpers, FMX.Platform.Android, Androidapi.JNI.Widget, FMX.Helpers.Android,
    Androidapi.JNI.Os, FMX.FontGlyphs.Android,
 	{$ENDIF}
  IdUDPBase, IdUDPClient, FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, System.DateUtils, idGlobal,
  FMX.Edit, FMX.ComboEdit, FMX.Objects, IdUDPServer, IdSocketHandle;

type TPacket = packed record
  msLen:Byte;
  colorarray:array [1..40,1..40] of cardinal;
  w:integer;
  h:integer;
  msg:string[255];
end;

const commands: array [1..17] of string = (
    'drawline', 'drawellipse', 'drawtext',
    'clear', 'drawimage',
    'fillroundedrectangle','drawpixel',
    'drawsymbol','setorientation','getwidth',
    'getheight','loadsprite','showsprite',
    'drawroundedrectangle', 'fillellipse',
    'drawcircle','fillcircle'
);

type TCommand=(DRAW_LINE, DRAW_ELLIPSE, DRAW_TEXT,
CLEAR, DRAW_IMAGE, FILL_ROUNDED_RECTANGLE,
DRAW_PIXEL, DRAW_SYMBOL, SET_ORIENTATION,
GET_WIDTH, GET_HEIGHT, LOAD_SPRITE, SHOW_SPRITE,
DRAW_ROUNDED_RECTANGLE, FILL_ELLIPSE, DRAW_CIRCLE,
FILL_CIRCLE, ERROR);

type
  TForm1 = class(TForm)
    IdUDPClient1: TIdUDPClient;
    Button1: TButton;
    Memo1: TMemo;
    ComboEdit1: TComboEdit;
    Label1: TLabel;
    Image1: TImage;
    Timer1: TTimer;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    bmp:TBitmap;
    packet:TPacket;
    send_data:TIdBytes;
    xx:Double;
    yy:integer;
    xx2:integer;
    yy2:integer;
    y:integer;
    x:integer;
    fi:double;
    sendcommand:TCommand;
    FPermissionWriteExternalStorage: string;
  public
    function DrawPixelEncode(const sendcommand, px1,py1,parcolor:string):string;
    function SetOrientationEncode(const sendcommand, deg:string):string;
    function GetWidthEncode(const sendcommand:string):string;
    function GetHeightEncode(const sendcommand:string):string;
    function DrawLineEncode(const sendcommand, parx1,pary1,parx2,pary2,parcolor:string):string;
    function DrawSymbolEncode(const sendcommand, symbol, x,y,parcolor:string):string;
    function DrawEllipseEncode(const sendcommand, elx1,ely1,elx2,ely2,parcolor:string):string;
    function DrawCircleEncode(const sendcommand, x0,y0,radius,parcolor:string):string;
    function FillCircleEncode(const sendcommand, x0,y0,radius,parcolor:string):string;
    function FillEllipseEncode(const sendcommand, elx1,ely1,elx2,ely2,parcolor:string):string;
    function DrawTextEncode(const sendcommand, tx1,ty1,tx2,ty2,text,parcolor:string):string;
    function ClearEncode(const sendcommand:string; const parcolor:string):string;
    function DrawImageEncode(const sendcommand:string; width,heigth:string):string;
    function ShowSpriteEncode(const sendcommand:string; index,x,y:string):string;
    function FillRoundedRectangleEncode(const sendcommand:string; px1,py1,px2,py2,radius,parcolor:string):string;
    function DrawRoundedRectangleEncode(const sendcommand:string; px1,py1,px2,py2,radius,parcolor:string):string;
    function LoadSpriteEncode(const sendcommand:string; width, heigth:string):string;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var spl:TArray<string>; s:string; i:integer; iw,jw:integer; b:TBitmapData;
begin

  packet.msLen:=Length(Memo1.Text);
  SetLength(packet.msg,packet.msLen);

  s:=Memo1.Text;
  spl:=s.Split([' ']);

  for i:=1 to Length(commands) do
  begin
    if commands[i]=spl[0] then
    begin
      sendcommand:=TCommand(i-1);
      case sendcommand of
      TCommand.DRAW_LINE:
        packet.msg:=DrawLineEncode((i-1).ToString,spl[1],spl[2],spl[3],spl[4],spl[5]);
      TCommand.DRAW_ELLIPSE:
        packet.msg:=DrawEllipseEncode((i-1).ToString,spl[1],spl[2],spl[3],spl[4],spl[5]);
      TCommand.DRAW_TEXT:
        packet.msg:=DrawTextEncode((i-1).ToString,spl[1],spl[2],spl[3],spl[4],spl[5],spl[6]);
      TCommand.CLEAR:
        packet.msg:=ClearEncode((i-1).ToString,spl[1]);
      TCommand.DRAW_IMAGE:
      begin
        packet.msg:=DrawImageEncode((i-1).ToString,spl[1],spl[2]);
        bmp:=TBitmap.CreateFromFile(spl[3]);

        packet.w:=bmp.Width;
        packet.h:=bmp.Height;


        bmp.Map(TMapAccess.Read,b);

        for iw:=1 to Round(bmp.Width) do
        for jw:=1 to Round(bmp.Height) do
          packet.colorarray[iw,jw]:=b.GetPixel(iw,jw);

        bmp.Unmap(b);
        Image1.Bitmap.Assign(bmp);

      end;
      TCommand.FILL_ROUNDED_RECTANGLE:
      begin
        packet.msg:=FillRoundedRectangleEncode((i-1).ToString,spl[1],spl[2],spl[3],spl[4],spl[5],spl[6]);
      end;
      TCommand.DRAW_PIXEL:
      begin
        packet.msg:=DrawPixelEncode((i-1).ToString,spl[1],spl[2],spl[3]);
      end;
      TCommand.DRAW_SYMBOL:
      begin
        packet.msg:=DrawSymbolEncode((i-1).ToString,spl[1],spl[2],spl[3],spl[4]);
      end;
      TCommand.SET_ORIENTATION:
      begin
        packet.msg:=SetOrientationEncode((i-1).ToString,spl[1]);
      end;
      TCommand.GET_WIDTH:
      begin
        packet.msg:=GetWidthEncode((i-1).ToString);
      end;
      TCommand.GET_HEIGHT:
      begin
        packet.msg:=GetHeightEncode((i-1).ToString);
      end;
      TCommand.LOAD_SPRITE:
      begin
        packet.msg:=LoadSpriteEncode((i-1).ToString,spl[1],spl[2]);
        bmp:=TBitmap.CreateFromFile(spl[3]);

        packet.w:=bmp.Width;
        packet.h:=bmp.Height;


        bmp.Map(TMapAccess.Read,b);

        for iw:=1 to Round(bmp.Width) do
        for jw:=1 to Round(bmp.Height) do
          packet.colorarray[iw,jw]:=b.GetPixel(iw,jw);

        bmp.Unmap(b);
        Image1.Bitmap.Assign(bmp);
      end;
      TCommand.SHOW_SPRITE:
      begin
        packet.msg:=DrawPixelEncode((i-1).ToString,spl[1],spl[2],spl[3]);
      end;
      TCommand.DRAW_ROUNDED_RECTANGLE:
      begin
        packet.msg:=DrawRoundedRectangleEncode((i-1).ToString,spl[1],spl[2],spl[3],spl[4],spl[5],spl[6]);
      end;
      TCommand.FILL_ELLIPSE:
      begin
        packet.msg:=FillEllipseEncode((i-1).ToString,spl[1],spl[2],spl[3],spl[4],spl[5]);
      end;
      TCommand.DRAW_CIRCLE:
      begin
        packet.msg:=DrawCircleEncode((i-1).ToString,spl[1],spl[2],spl[3],spl[4]);
      end;
      TCommand.FILL_CIRCLE:
      begin
        packet.msg:=FillCircleEncode((i-1).ToString,spl[1],spl[2],spl[3],spl[4]);
      end;
      end;
    end;
  end;

  IdUDPClient1.Active:=true;
  IdUDPClient1.Port:=5000;
  IdUDPClient1.Host:=ComboEdit1.Text;
  IdUDPClient1.Connect;

  if IdUDPClient1.Connected then
  begin
    SetLength(send_data,sizeof(packet));
    Move(packet,send_data[0],sizeof(packet));
    IdUDPClient1.SendBuffer(send_data);
  end;

  IdUDPClient1.Active:=false;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Timer1.Enabled:=not Timer1.Enabled;
end;

function TForm1.ClearEncode(const sendcommand:string; const parcolor: string): string;
var command:integer; color:integer;
begin
try
    command:=Integer.Parse(sendcommand);
    color:=Integer.Parse('$ff'+parcolor);
    Result:=command.ToString+' '+parcolor;
except on EConvertError do
begin
    Result:='17';
end;
end;
end;

function TForm1.DrawSymbolEncode(const sendcommand, symbol, x, y, parcolor: string): string;
var xx,yy: Double; command:integer; color:integer;
begin
  try
    xx:=Double.Parse(x);
    yy:=Double.Parse(y);
    command:=Integer.Parse(sendcommand);
    color:=Integer.Parse('$ff'+parcolor);
    Result:=command.ToString+' '+symbol+' '+xx.ToString+' '+yy.ToString+' '+parcolor;
  except on EConvertError do
  begin
    Result:='17';
  end;
end;
end;

function TForm1.DrawCircleEncode(const sendcommand, x0, y0, radius,
  parcolor: string): string;
var x1,y1,rad,command,color:integer;
begin
  try
    x1:=Integer.Parse(x0);
    y1:=Integer.Parse(y0);
    rad:=Integer.Parse(radius);
    color:=Integer.Parse('$ff'+parcolor);
    command:=Integer.Parse(sendcommand);
    Result:=command.ToString+' '+x1.ToString+' '+y1.ToString+' '+rad.ToString+' '+parcolor;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;

function TForm1.DrawEllipseEncode(const sendcommand, elx1, ely1, elx2, ely2,
  parcolor: string): string;
var x1,y1,x2,y2,command,color:integer;
begin
  try
    x1:=Integer.Parse(elx1);
    y1:=Integer.Parse(ely1);
    x2:=Integer.Parse(elx2);
    y2:=Integer.Parse(ely2);
    color:=Integer.Parse('$ff'+parcolor);
    command:=Integer.Parse(sendcommand);
    Result:=command.ToString+' '+x1.ToString+' '+y1.ToString+' '+x2.ToString+' '+y2.ToString+' '+parcolor;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;

function TForm1.DrawImageEncode(const sendcommand: string; width,
  heigth: string): string;
var w,h,command:integer;
begin
  try
    w:=Integer.Parse(width);
    h:=Integer.Parse(heigth);
    command:=Integer.Parse(sendcommand);
    Result:=command.ToString+' '+w.ToString+' '+h.ToString;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;

function TForm1.DrawLineEncode(const sendcommand, parx1, pary1, parx2, pary2,
  parcolor: string): string;
var x1,y1,x2,y2,command,color:integer;
begin
  try
    x1:=Integer.Parse(parx1);
    y1:=Integer.Parse(pary1);
    x2:=Integer.Parse(parx2);
    y2:=Integer.Parse(pary2);
    color:=Integer.Parse('$ff'+parcolor);
    command:=Integer.Parse(sendcommand);
    Result:=command.ToString+' '+x1.ToString+' '+y1.ToString+' '+x2.ToString+' '
    +y2.ToString+' '+parcolor;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;

function TForm1.DrawPixelEncode(const sendcommand, px1, py1,
  parcolor: string): string;
var x1,y1,command,color:integer;
begin
  try
    x1:=Integer.Parse(px1);
    y1:=Integer.Parse(py1);
    command:=Integer.Parse(sendcommand);
    color:=Integer.Parse('$ff'+parcolor);
    Result:=command.ToString+' '+x1.ToString+' '+y1.ToString+' '+parcolor;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;

function TForm1.DrawRoundedRectangleEncode(const sendcommand: string; px1, py1,
  px2, py2, radius, parcolor: string): string;
var x1,y1,x2,y2,rad,command,color:integer;
begin
  try
    x1:=Integer.Parse(px1);
    y1:=Integer.Parse(py1);
    x2:=Integer.Parse(px2);
    y2:=Integer.Parse(py2);
    rad:=Integer.Parse(radius);
    command:=Integer.Parse(sendcommand);
    color:=Integer.Parse('$ff'+parcolor);
    Result:=command.ToString+' '+x1.ToString+' '+y1.ToString+' '+
    x2.ToString+' '+y2.ToString+' '+rad.ToString+' '+parcolor;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;

function TForm1.DrawTextEncode(const sendcommand, tx1, ty1, tx2, ty2, text,
  parcolor: string): string;
var x1,y1,x2,y2,command,color:integer;
begin
  try
    x1:=Integer.Parse(tx1);
    y1:=Integer.Parse(ty1);
    x2:=Integer.Parse(tx2);
    y2:=Integer.Parse(ty2);
    color:=Integer.Parse('$ff'+parcolor);
    command:=Integer.Parse(sendcommand);
    Result:=command.ToString+' '+x1.ToString+' '+y1.ToString+' '+x2.ToString+' '
    +y2.ToString+' '+text+' '+parcolor;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;

function TForm1.FillCircleEncode(const sendcommand, x0, y0, radius,
  parcolor: string): string;
var x1,y1,rad,command,color:integer;
begin
  try
    x1:=Integer.Parse(x0);
    y1:=Integer.Parse(y0);
    rad:=Integer.Parse(radius);
    color:=Integer.Parse('$ff'+parcolor);
    command:=Integer.Parse(sendcommand);
    Result:=command.ToString+' '+x1.ToString+' '+y1.ToString+' '+rad.ToString+' '+parcolor;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;

function TForm1.FillEllipseEncode(const sendcommand, elx1, ely1, elx2, ely2,
  parcolor: string): string;
var x1,y1,x2,y2,command,color:integer;
begin
  try
    x1:=Integer.Parse(elx1);
    y1:=Integer.Parse(ely1);
    x2:=Integer.Parse(elx2);
    y2:=Integer.Parse(ely2);
    color:=Integer.Parse('$ff'+parcolor);
    command:=Integer.Parse(sendcommand);
    Result:=command.ToString+' '+x1.ToString+' '+y1.ToString+' '+x2.ToString+' '+y2.ToString+' '+parcolor;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;

function TForm1.FillRoundedRectangleEncode(const sendcommand: string; px1, py1,
  px2, py2, radius, parcolor: string): string;
var x1,y1,x2,y2,rad,command,color:integer;
begin
  try
    x1:=Integer.Parse(px1);
    y1:=Integer.Parse(py1);
    x2:=Integer.Parse(px2);
    y2:=Integer.Parse(py2);
    rad:=Integer.Parse(radius);
    command:=Integer.Parse(sendcommand);
    color:=Integer.Parse('$ff'+parcolor);
    Result:=command.ToString+' '+x1.ToString+' '+y1.ToString+' '+
    x2.ToString+' '+y2.ToString+' '+rad.ToString+' '+parcolor;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  xx:=0;
  yy:=0;
  xx2:=0;
  fi:=0;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
{$IFDEF ANDROID}
    FPermissionWriteExternalStorage:=JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
    PermissionsService.RequestPermissions([FPermissionWriteExternalStorage],
  procedure(const APermissions: TArray<string>; const AGrantResults: TArray<TPermissionStatus>)
  var i:integer;
  begin
       for i:=0 to Length(AGrantResults) do
       begin
          if AGrantResults[i] = TPermissionStatus.Granted then
          begin
            case i of
            0:
            TJToast.JavaClass.makeText(TAndroidHelper.Context, StrToJCharSequence('����� � �����i��� ������ ���������!'), TJToast.JavaClass.LENGTH_LONG).show;
            end;
          end
          Else
          begin
            case i of
            0:
            TJToast.JavaClass.makeText(TAndroidHelper.Context, StrToJCharSequence('����� ���������!'), TJToast.JavaClass.LENGTH_LONG).show;
            end;
          end;
       end;
  end)
{$ENDIF}
end;

function TForm1.GetHeightEncode(const sendcommand: string): string;
var command:integer;
begin
  try
    Result:=command.ToString;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;

function TForm1.GetWidthEncode(const sendcommand: string): string;
var command:integer;
begin
  try
    Result:=command.ToString;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;


function TForm1.LoadSpriteEncode(const sendcommand: string; width,
  heigth: string): string;
var w,h,command:integer;
begin
  try
    w:=Integer.Parse(width);
    h:=Integer.Parse(heigth);
    command:=Integer.Parse(sendcommand);
    Result:=command.ToString+' '+w.ToString+' '+h.ToString;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;

function TForm1.SetOrientationEncode(const sendcommand, deg: string): string;
var command,degrees:integer;
begin
  try
    degrees:=Integer.Parse(deg);
    command:=Integer.Parse(sendcommand);
    Result:=command.ToString+' '+degrees.ToString;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;

function TForm1.ShowSpriteEncode(const sendcommand: string; index, x,
  y: string): string;
var ind,xpos,ypos,command:integer;
begin
  try
    ind:=Integer.Parse(index);
    xpos:=Integer.Parse(x);
    ypos:=Integer.Parse(y);
    command:=Integer.Parse(sendcommand);
    Result:=command.ToString+' '+ind.ToString+' '+xpos.ToString+' '+ypos.ToString;
  except on EConvertError do
  begin
    Result:='17';
  end;
  end;
end;


procedure SendData(const scommand:string);
begin
with Form1 do
begin
  packet.msLen:=Length(scommand);
  SetLength(packet.msg,packet.msLen);

  packet.msg:=scommand;

  IdUDPClient1.Active:=true;
  IdUDPClient1.Port:=5000;
  IdUDPClient1.Host:=ComboEdit1.Text;
  IdUDPClient1.Connect;

  if IdUDPClient1.Connected then
  begin
    SetLength(send_data,sizeof(packet));
    Move(packet,send_data[0],sizeof(packet));
    IdUDPClient1.SendBuffer(send_data);
  end;

  IdUDPClient1.Active:=false;
end;
end;



procedure TForm1.Timer1Timer(Sender: TObject);
var s:string;
 i:integer;
 scommand:string; enum:TCommand;
 t:TDateTime;
 p1,p2:integer;
 color:string;
 stime:string;
 yposition:integer;
begin

  Timer1.Enabled:=false;


  if 2*pi>fi then
  begin
    x:=200+Round(40*((2-0.5*sin(50*fi)+cos(7*fi))*cos(fi)));
    y:=200+Round(40*((2-0.5*sin(50*fi)+cos(7*fi))*sin(fi)));
    fi:=fi+0.001;
  end;

  enum:=TCommand.DRAW_PIXEL;

  scommand:=DrawPixelEncode(IntToStr(Integer(enum)),x.ToString,y.ToString,'FF007B');

  SendData(scommand);

  Timer1.Enabled:=true;

end;

end.
