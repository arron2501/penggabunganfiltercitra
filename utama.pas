unit Utama;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtDlgs,
  ExtCtrls, Windows;

var
  bitmapR1, bitmapG1, bitmapB1 : array [0..1000, 0..1000] of byte;
  bitmapR2, bitmapG2, bitmapB2 : array [0..1000, 0..1000] of byte;

type

  { TFormUtama }

  TFormUtama = class(TForm)
    ButtonGambar1: TButton;
    ButtonGambar2: TButton;
    ButtonProses: TButton;
    ButtonSimpan: TButton;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Title: TLabel;
    OpenPicture1: TOpenPictureDialog;
    OpenPicture2: TOpenPictureDialog;
    SavePicture: TSavePictureDialog;
    ScrollBox1: TScrollBox;
    ScrollBox2: TScrollBox;
    ScrollBox3: TScrollBox;
    procedure ButtonProsesClick(Sender: TObject);
    procedure ButtonGambar1Click(Sender: TObject);
    procedure ButtonGambar2Click(Sender: TObject);
    procedure ButtonSimpanClick(Sender: TObject);
  private

  public

  end;

var
  FormUtama: TFormUtama;

implementation

{$R *.lfm}

{ TFormUtama }

procedure TFormUtama.ButtonGambar1Click(Sender: TObject);
var
  x, y: integer;
begin
  if OpenPicture1.Execute then
  begin
    Image1.Picture.LoadFromFile(OpenPicture1.FileName);
    for y:=0 to Image1.Height-1 do
    begin
      for x:=0 to Image1.Width-1 do
      begin
        bitmapR1[x,y] := GetRValue(Image1.Canvas.Pixels[x,y]);
        bitmapG1[x,y] := GetGValue(Image1.Canvas.Pixels[x,y]);
        bitmapB1[x,y] := GetBValue(Image1.Canvas.Pixels[x,y]);
      end;
    end;
  end;
end;

procedure TFormUtama.ButtonGambar2Click(Sender: TObject);
var
  x, y: integer;
begin
  if OpenPicture2.Execute then
  begin
    Image2.Picture.LoadFromFile(OpenPicture2.FileName);
    for y:=0 to Image2.Height-1 do
    begin
      for x:=0 to Image2.Width-1 do
      begin
        bitmapR2[x,y] := GetRValue(Image2.Canvas.Pixels[x,y]);
        bitmapG2[x,y] := GetGValue(Image2.Canvas.Pixels[x,y]);
        bitmapB2[x,y] := GetBValue(Image2.Canvas.Pixels[x,y]);
      end;
    end;
    ButtonProses.Enabled := True;
  end;
end;

procedure TFormUtama.ButtonProsesClick(Sender: TObject);
var
  // Inisialisasi variabel yang akan digunakan.
  value : array [0..2, 0..2] of integer;
  gray: byte;
  i, j, r, g, b, inversR, inversG, inversB: integer;
begin
  Image3.Picture := nil;
  Image3.Picture := Image1.Picture;
  // Setting nilai value untuk proses edge detection.
  // Pada kali ini saya menerapkan edge detection
  // dengan operator Laplacian 2.
  value[0, 0] := -1;
  value[0, 1] := -1;
  value[0, 2] := -1;
  value[1, 0] := -1;
  value[1, 1] := 8;
  value[1, 2] := -1;
  value[2, 0] := -1;
  value[2, 1] := -1;
  value[2, 2] := -1;

  // Looping untuk proses pengolahan gambar.
  for j := 1 to Image1.Height do
  begin
    for i := 1 to Image1.Width do
    begin
      // Memulai proses pengolahan gambar menjadi Sketch (Edge Detection).
      // [1]
      r := (bitmapR1[i-1, j-1] * value[0, 0] + bitmapR1[i-1, j] * value[0, 1] + bitmapR1[i-1, j+1] * value[0, 2] +
            bitmapR1[i, j-1]   * value[1, 0] + bitmapR1[i, j]   * value[1, 1] + bitmapR1[i, j+1]   * value[1, 2] +
            bitmapR1[i+1, j-1] * value[2, 0] + bitmapR1[i+1, j] * value[2, 1] + bitmapR1[i+1, j+1] * value[2, 2] +
            bitmapR2[i-1, j-1] * value[0, 0] + bitmapR2[i-1, j] * value[0, 1] + bitmapR2[i-1, j+1] * value[0, 2] +
            bitmapR2[i, j-1]   * value[1, 0] + bitmapR2[i, j]   * value[1, 1] + bitmapR2[i, j+1]   * value[1, 2] +
            bitmapR2[i+1, j-1] * value[2, 0] + bitmapR2[i+1, j] * value[2, 1] + bitmapR2[i+1, j+1] * value[2, 2]);
      if(r > 255) then r := 255
      else if(r < 0) then r := 0
      else round(r);

      g := (bitmapG1[i-1, j-1] * value[0, 0] + bitmapG1[i-1, j] * value[0, 1] + bitmapG1[i-1, j+1] * value[0, 2] +
            bitmapG1[i, j-1]   * value[1, 0] + bitmapG1[i, j]   * value[1, 1] + bitmapG1[i, j+1]   * value[1, 2] +
            bitmapG1[i+1, j-1] * value[2, 0] + bitmapG1[i+1, j] * value[2, 1] + bitmapG1[i+1, j+1] * value[2, 2] +
            bitmapG2[i-1, j-1] * value[0, 0] + bitmapG2[i-1, j] * value[0, 1] + bitmapG2[i-1, j+1] * value[0, 2] +
            bitmapG2[i, j-1]   * value[1, 0] + bitmapG2[i, j]   * value[1, 1] + bitmapG2[i, j+1]   * value[1, 2] +
            bitmapG2[i+1, j-1] * value[2, 0] + bitmapG2[i+1, j] * value[2, 1] + bitmapG2[i+1, j+1] * value[2, 2]);
      if(g > 255) then g := 255
      else if(g < 0) then g := 0
      else round(g);

      b := (bitmapB1[i-1, j-1] * value[0, 0] + bitmapB1[i-1, j] * value[0, 1] + bitmapB1[i-1, j+1] * value[0, 2] +
            bitmapB1[i, j-1]   * value[1, 0] + bitmapB1[i, j]   * value[1, 1] + bitmapB1[i, j+1]   * value[1, 2] +
            bitmapB1[i+1, j-1] * value[2, 0] + bitmapB1[i+1, j] * value[2, 1] + bitmapB1[i+1, j+1] * value[2, 2] +
            bitmapB2[i-1, j-1] * value[0, 0] + bitmapB2[i-1, j] * value[0, 1] + bitmapB2[i-1, j+1] * value[0, 2] +
            bitmapB2[i, j-1]   * value[1, 0] + bitmapB2[i, j]   * value[1, 1] + bitmapB2[i, j+1]   * value[1, 2] +
            bitmapB2[i+1, j-1] * value[2, 0] + bitmapB2[i+1, j] * value[2, 1] + bitmapB2[i+1, j+1] * value[2, 2]);
      if(b > 255) then b := 255
      else if(b < 0) then b := 0
      else round(b);

      inversB := 255 - b;
      inversG := 255 - g;
      inversR := 255 - r;

      gray := (inversB + inversG + inversR) div 3;
      Image3.Canvas.Pixels[i, j] := RGB(gray, gray, gray);
    end;
  end;
  ButtonSimpan.Enabled := True;
end;

procedure TFormUtama.ButtonSimpanClick(Sender: TObject);
begin
  if SavePicture.Execute then
  begin
    Image3.Picture.SaveToFile(SavePicture.FileName);
  end;
end;

end.

