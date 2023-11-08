unit MyCommands;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, IdBaseComponent, IdComponent,
  IdUDPBase, IdUDPServer, IdGlobal, IdSocketHandle, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, System.DateUtils, FMX.Objects, System.Generics.Collections;

type
  TMyCommands=class
  public
  class var linepath : TPathData;
  class var ellipsepath : TPathData;
  class var spritewidth : Double;
  class var spriteheight : Double;
  class var spritexpos : Double;
  class var spriteypos : Double;
  class var spriteindex : integer;
  class var p1 : TPointF;
  class var p2 : TPointF;
  class var sx : Double;
  class var sy : Double;
  class var circleX0 : Integer;
  class var circleY0 : Integer;
  class var CircleRadius : Integer;
  class var CircleColor : string;
  class var degrees : integer;
  class var symbol : string;
  class var ppoint : TPointF;
  class var linecolor:string;
  class var ellipsecolor:string;
  class var textcolor:string;
  class var symbolcolor:string;
  class var pixelcolor:string;
  class var fillroundedrectanglecolor:string;
  class var clearcolor:string;
  class var ximage,yimage:Double;
  class var x1_text,y1_text,x2_text,y2_text:Double;
  class var x1,y1,x2,y2,radius:Integer;
  class var x1_ellipse,y1_ellipse,x2_ellipse,y2_ellipse:Double;
  class var textout:string;
  class procedure DrawImage(const x, y: double; const bmp: TBitmap; const Canvas:TCanvas);
  class procedure ShowSprite(const x, y, w, h: double; const bmp: TBitmap; const Canvas:TCanvas);
  class procedure DrawMyLine(const p1,p2:TPointF;const Canvas:TCanvas; const color:Cardinal);
  class procedure DrawMyPixel(const ppoint:TPointF; const Canvas:TCanvas; const color:Cardinal);
  class procedure DrawSymbol(const mysymbol:integer; ppoint:TPointF; const Canvas:TCanvas; const color:Cardinal);
  class procedure DrawMyEllipse(const x1_ellipse,y1_ellipse,x2_ellipse,y2_ellipse:Double; const Canvas:TCanvas; const color:Cardinal);
  class procedure DrawMyCircle(const x0,y0,radius:Integer; const Canvas:TCanvas; const color:Cardinal);
  class procedure FillMyCircle(const x0,y0,radius:Integer; const Canvas:TCanvas; const color:Cardinal);
  class procedure FillMyEllipse(const x1_ellipse,y1_ellipse,x2_ellipse,y2_ellipse:Double; const Canvas:TCanvas; const color:Cardinal);
  class procedure FillRoundedRectangle(const x1,y1,x2,y2,radius:Integer; const Canvas:TCanvas; const color:Cardinal);
  class procedure DrawRoundedRectangle(const x1,y1,x2,y2,radius:Integer; const Canvas:TCanvas; const color:Cardinal);
  class procedure DrawMyText(const x1_text,y1_text,x2_text,y2_text:Double; const textout:string; const fontsize:integer; const Canvas:TCanvas; const color:Cardinal);
  class procedure ClearCanvas(const Form:TForm; const Canvas:TCanvas; const color:Cardinal);
  class function PreparePixel(const x1,y1,parcolor:string):integer;
  class function PrepareLine(const parx1,pary1,parx2,pary2,parcolor:string):integer;
  class function PrepareEllipse(const elx1,ely1,elx2,ely2,parcolor:string):integer;
  class function PrepareCircle(const x0,y0,radius,parcolor:string):integer;
  class function PrepareText(const tx1,ty1,tx2,ty2,text,parcolor:string):integer;
  class function PrepareSymbol(const symbol, sx, sy,parcolor:string):integer;
  class function PrepareFillRoundedRectangle(const x1,y1,x2,y2,rad,parcolor:string):integer;
  class function PrepareDrawRoundedRectangle(const x1,y1,x2,y2,rad,parcolor:string):integer;
  class function PrepareClear(parcolor:string):integer;
  class function PrepareDrawImage(x,y:string):integer;
  class function PrepareLoadSprite(width,height:string):integer;
  class function PrepareShowSprite(index,x,y:string):integer;
  class function PrepareOrientation(deg:string):integer;
end;


implementation


class procedure TMyCommands.ClearCanvas(const Form:TForm; const Canvas:TCanvas; const color: Cardinal);
begin
  Canvas.Clear(color);
  Form.Fill.Color:=color;
end;

class procedure TMyCommands.DrawSymbol(const mysymbol:integer; ppoint: TPointF; const Canvas: TCanvas;
  const color: Cardinal);
var p1,p2:TPointF; xcenter,ycenter:Double;
begin
  Canvas.Stroke.Color:=color;
  Canvas.Stroke.Thickness:=3;

  case mysymbol of
  0:  // �
  begin
    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;
    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter);
    Canvas.DrawLine(p1,p2,1.0);
    p1:=TPointF.Create(xcenter,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter);
    Canvas.DrawLine(p1,p2,1.0);
    p1:=TPointF.Create(xcenter,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter);
    Canvas.DrawLine(p1,p2,1.0);
    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter-10,ycenter+20);
    Canvas.DrawLine(p1,p2,1.0);
    p1:=TPointF.Create(xcenter+10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter+20);
    Canvas.DrawLine(p1,p2,1.0);
  end;
  1:  // �
  begin

    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter-10);
    p2:=TPointF.Create(xcenter-10,ycenter-20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter-10);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter+10);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter+20);
    p2:=TPointF.Create(xcenter+10,ycenter+10);

    Canvas.DrawLine(p1,p2,1.0);

  end;
  2:  // �
  begin

    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter-20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

  end;
  3:  // D
  begin

    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter+20);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

  end;
  4: //E
  begin
  xcenter:=ppoint.X;
  ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter-20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter+20);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

  end;
  5: //F
  begin
  xcenter:=ppoint.X;
  ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter-20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

  end;
  6: //G
  begin
   xcenter:=ppoint.X;
   ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter-20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter+20);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter+20);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

  end;
  7: //H
  begin
    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);
    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);
  end;
  8: //1
  begin
    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter+10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);
  end;
  9: //2
  begin
    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter-20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter);
    p2:=TPointF.Create(xcenter-10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter+20);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);
  end;
  10: //3
  begin
    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter-20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter);
    p2:=TPointF.Create(xcenter-10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter+20);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);
  end;
  11: //4
  begin
    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter);
    p2:=TPointF.Create(xcenter-10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);
  end;
  12: //5
  begin
    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter-20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter+20);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);
  end;
  13: //6
  begin
    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter-20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter+20);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter-10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);
  end;
  14: //7
  begin
    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter+10,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter-20);

    Canvas.DrawLine(p1,p2,1.0);
  end;
  15: //8
  begin
    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter-20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter+20);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter-10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);
  end;
  16: //9
  begin
    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter-20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter+20);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);
  end;
  17: //0
  begin
    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter-20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter-20);
    p2:=TPointF.Create(xcenter-10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter+20);
    p2:=TPointF.Create(xcenter+10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter-10,ycenter);
    p2:=TPointF.Create(xcenter-10,ycenter+20);

    Canvas.DrawLine(p1,p2,1.0);

    p1:=TPointF.Create(xcenter+10,ycenter-20);
    p2:=TPointF.Create(xcenter+10,ycenter);

    Canvas.DrawLine(p1,p2,1.0);
  end;
  18: // :
  begin
    xcenter:=ppoint.X;
    ycenter:=ppoint.Y;

    p1:=TPointF.Create(xcenter,ycenter-10);
    p2:=TPointF.Create(xcenter,ycenter+10);

    Canvas.DrawArc(p1,TPoint.Create(3,3),-90,360,1.0);
    Canvas.DrawArc(p2,TPoint.Create(3,3),-90,360,1.0);
  end;
  end;
end;

class procedure TMyCommands.DrawImage(const x, y: double; const bmp: TBitmap; const Canvas:TCanvas);
begin
    Canvas.DrawBitmap(bmp, TRectF.Create(0, 0, bmp.Width, bmp.Height),
    TRectF.Create(0 + x, 0 + y, bmp.Width + x, bmp.Height + y), 1.0, true);
end;

class procedure TMyCommands.DrawMyCircle(const x0, y0, radius: Integer;
  const Canvas: TCanvas; const color: Cardinal);
var p,rad:TPoint;
begin
  Canvas.Stroke.Color:=color;
  Canvas.Stroke.Thickness:=4;
  p:=TPoint.Create(x0,y0);
  rad:=TPoint.Create(radius,radius);
  Canvas.DrawArc(p,rad,-90,360,1.0);
end;

class procedure TMyCommands.DrawMyEllipse(const x1_ellipse, y1_ellipse,
  x2_ellipse, y2_ellipse: Double; const Canvas: TCanvas; const color: Cardinal);
var rect:TRectF;
begin
  rect:=TRectF.Create(x1_ellipse,y1_ellipse,x2_ellipse,y2_ellipse);
  Canvas.Stroke.Color:=color;
  Canvas.Stroke.Thickness:=3;
  Canvas.Stroke.Dash:=TStrokeDash.Solid;
  Canvas.DrawEllipse(rect,1.0);
end;

class procedure TMyCommands.DrawMyLine(const p1, p2: TPointF;
  const Canvas: TCanvas; const color: Cardinal);
begin
  Canvas.Stroke.Color:=color;
  Canvas.Stroke.Thickness:=5;
  Canvas.Stroke.Dash:=TStrokeDash.Solid;
  Canvas.DrawLine(p1,p2,1.0);
end;

class procedure TMyCommands.DrawMyPixel(const ppoint: TPointF;
  const Canvas: TCanvas; const color: Cardinal);
var PixelRegion: TRectF; PixelPos: TPointF;
begin
  Canvas.Stroke.Color:=color;
  Canvas.Stroke.Thickness:=1;
  PixelPos := Canvas.AlignToPixel(ppoint);
  PixelRegion := TRectF.Create(PixelPos, 1, 1);
  Canvas.DrawRect(PixelRegion, 0, 0, AllCorners, 1);
end;

class procedure TMyCommands.DrawMyText(const x1_text, y1_text, x2_text,
  y2_text: Double; const textout: string; const fontsize: integer;
  const Canvas: TCanvas; const color: Cardinal);
begin
  Canvas.Font.Size:=fontsize;
  Canvas.Font.Style:=[TFontStyle.fsBold];
  Canvas.Fill.Color:=color;
  Canvas.FillText(TRectF.Create(x1_text,y1_text,x2_text,y2_text),textout,true,1.0,[],TTextAlign.Leading,TTextAlign.Leading);
end;

class procedure TMyCommands.DrawRoundedRectangle(const x1, y1, x2, y2,
  radius: Integer; const Canvas: TCanvas; const color: Cardinal);
begin
  Canvas.Stroke.Color:=color;
  Canvas.Stroke.Thickness:=5;
  Canvas.DrawRect(TRectF.Create(x1,y1,x2,y2),radius,radius,[TCorner.TopRight,TCorner.BottomRight,TCorner.TopLeft,TCorner.BottomLeft],1);
end;

class procedure TMyCommands.FillMyCircle(const x0, y0, radius: Integer;
  const Canvas: TCanvas; const color: Cardinal);
var p,rad:TPoint;
begin
  Canvas.Fill.Color:=color;
  p:=TPoint.Create(x0,y0);
  rad:=TPoint.Create(radius,radius);
  Canvas.FillArc(p,rad,-90,360,1.0);
end;

class procedure TMyCommands.FillMyEllipse(const x1_ellipse, y1_ellipse,
  x2_ellipse, y2_ellipse: Double; const Canvas: TCanvas; const color: Cardinal);
var rect:TRectF;
begin
  rect:=TRectF.Create(x1_ellipse,y1_ellipse,x2_ellipse,y2_ellipse);
  Canvas.Fill.Color:=color;
  Canvas.FillEllipse(rect,1.0);
end;

class procedure TMyCommands.FillRoundedRectangle(const x1,y1,x2,y2,
  radius: Integer; const Canvas: TCanvas; const color: Cardinal);
begin
  Canvas.Fill.Color:=color;
  Canvas.FillRect(TRectF.Create(x1,y1,x2,y2),radius,radius,[TCorner.TopRight,TCorner.BottomRight,TCorner.TopLeft,TCorner.BottomLeft],1);
end;

class procedure TMyCommands.ShowSprite(const x, y, w, h: double; const bmp: TBitmap; const Canvas:TCanvas);
begin
  Canvas.DrawBitmap(bmp, TRectF.Create(0, 0, bmp.Width, bmp.Height),
    TRectF.Create(0 + x, 0 + y, w + x, h + y), 1.0, true);
end;

class function TMyCommands.PrepareShowSprite(index, x, y: string): integer;
begin
  try
    spritexpos:=Double.Parse(x);
    spriteypos:=Double.Parse(y);
    spriteindex:=Integer.Parse(index);
    Result:=1;
  except on EConvertError do
  begin
    Result:=0;
  end;
  end;
end;

class function TMyCommands.PrepareSymbol(const symbol, sx, sy, parcolor: string): integer;
begin
  try
    Self.sx:=Double.Parse(sx);
    Self.sy:=Double.Parse(sy);
    symbolcolor:=parcolor;
    Self.symbol:=symbol;
    Result:=1;
  except on EConvertError do
  begin
    Result:=0;
  end;
  end;
end;

class function TMyCommands.PrepareCircle(const x0, y0, radius,
  parcolor: string): integer;
begin
  try
    circleX0:=Integer.Parse(x0);
    circleY0:=Integer.Parse(y0);
    CircleRadius:=Integer.Parse(radius);
    CircleColor:=parcolor;
    Result:=1;
  except on EConvertError do
  begin
    Result:=0;
  end;
  end;
end;

class function TMyCommands.PrepareClear(parcolor: string): integer;
begin
  try
    clearcolor:=parcolor;
    Result:=1;
  except on EConvertError do
  begin
    Result:=0;
  end;
  end;
end;

class function TMyCommands.PrepareDrawImage(x,y:string): integer;
begin
  try
    ximage:=Double.Parse(x);
    yimage:=Double.Parse(y);
    Result:=1;
  except on EConvertError do
  begin
    Result:=0;
  end;
  end;
end;

class function TMyCommands.PrepareDrawRoundedRectangle(const x1, y1, x2, y2,
  rad, parcolor: string): integer;
begin
  try
    Self.x1:=Integer.Parse(x1);
    Self.y1:=Integer.Parse(y1);
    Self.x2:=Integer.Parse(x2);
    Self.y2:=Integer.Parse(y2);
    fillroundedrectanglecolor:=parcolor;
    radius:=Integer.Parse(rad);
    Result:=1;
  except on EConvertError do
  begin
    Result:=0;
  end;
  end;
end;

class function TMyCommands.PrepareEllipse(const elx1, ely1, elx2, ely2,
  parcolor: string): integer;
begin
  try
    x1_ellipse:=Double.Parse(elx1);
    y1_ellipse:=Double.Parse(ely1);
    x2_ellipse:=Double.Parse(elx2);
    y2_ellipse:=Double.Parse(ely2);
    ellipsecolor:=parcolor;
    Result:=1;
  except on EConvertError do
  begin
    Result:=0;
  end;
  end;
end;

class function TMyCommands.PrepareFillRoundedRectangle(const x1, y1, x2, y2,
  rad, parcolor: string): integer;
begin
  try
    Self.x1:=Integer.Parse(x1);
    Self.y1:=Integer.Parse(y1);
    Self.x2:=Integer.Parse(x2);
    Self.y2:=Integer.Parse(y2);
    fillroundedrectanglecolor:=parcolor;
    radius:=Integer.Parse(rad);
    Result:=1;
  except on EConvertError do
  begin
    Result:=0;
  end;
  end;
end;

class function TMyCommands.PrepareLine(const parx1, pary1, parx2,
  pary2, parcolor : string): integer;
begin
  try
    p1.X:=Double.Parse(parx1);
    p1.Y:=Double.Parse(pary1);
    p2.X:=Double.Parse(parx2);
    p2.Y:=Double.Parse(pary2);
    linecolor:=parcolor;
    Result:=1;
  except on EConvertError do
  begin
    ShowMessage('���i��� �����i ���������� �i�ii!!!');
    Result:=0;
  end;
  end;
end;


class function TMyCommands.PrepareLoadSprite(width,height:string): integer;
begin
  try
    spritewidth:=Double.Parse(width);
    spriteheight:=Double.Parse(height);
    Result:=1;
  except on EConvertError do
  begin
    Result:=0;
  end;
  end;
end;

class function TMyCommands.PrepareOrientation(deg: string): integer;
begin
  try
    Self.degrees:=Integer.Parse(deg);
    Result:=1;
  except on EConvertError do
  begin
    ShowMessage('���i���� ���!!!');
    Result:=0;
  end;
  end;
end;

class function TMyCommands.PreparePixel(const x1, y1,
  parcolor: string): integer;
begin
  try
    ppoint.X:=Double.Parse(x1);
    ppoint.Y:=Double.Parse(y1);
    pixelcolor:=parcolor;
    Result:=1;
  except on EConvertError do
  begin
    ShowMessage('���i��� �����i ���������� �i�����!!!');
    Result:=0;
  end;
  end;
end;

class function TMyCommands.PrepareText(const tx1, ty1, tx2, ty2, text,
  parcolor: string): integer;
begin
  try
    x1_text:=Double.Parse(tx1);
    y1_text:=Double.Parse(ty1);
    x2_text:=Double.Parse(tx2);
    y2_text:=Double.Parse(ty2);
    textcolor:=parcolor;
    textout:=text;
    Result:=1;
  except on EConvertError do
  begin
    Result:=0;
  end;
  end;
end;

end.