Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.Drawing

$projectRoot = Split-Path -Parent $PSScriptRoot

function New-DirectoryIfMissing {
  param([string]$Path)

  if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

function Get-ArgbColor {
  param(
    [int]$A,
    [int]$R,
    [int]$G,
    [int]$B
  )

  [System.Drawing.Color]::FromArgb($A, $R, $G, $B)
}

function New-Canvas {
  param(
    [int]$Width,
    [int]$Height
  )

  $bitmap = [System.Drawing.Bitmap]::new($Width, $Height)
  $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
  $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $graphics.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $graphics.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $graphics.CompositingQuality = [System.Drawing.Drawing2D.CompositingQuality]::HighQuality

  @{
    Bitmap = $bitmap
    Graphics = $graphics
  }
}

function New-RoundedRectPath {
  param(
    [single]$Width,
    [single]$Height,
    [single]$Radius
  )

  $diameter = $Radius * 2
  $path = [System.Drawing.Drawing2D.GraphicsPath]::new()
  $path.AddArc(0, 0, $diameter, $diameter, 180, 90)
  $path.AddArc($Width - $diameter, 0, $diameter, $diameter, 270, 90)
  $path.AddArc($Width - $diameter, $Height - $diameter, $diameter, $diameter, 0, 90)
  $path.AddArc(0, $Height - $diameter, $diameter, $diameter, 90, 90)
  $path.CloseFigure()
  $path
}

function Draw-BrandCore {
  param(
    [System.Drawing.Graphics]$Graphics,
    [int]$Size,
    [bool]$Maskable = $false
  )

  $Graphics.Clear([System.Drawing.Color]::Transparent)

  $radius = if ($Maskable) { [single]($Size * 0.26) } else { [single]($Size * 0.24) }
  $rect = [System.Drawing.RectangleF]::new(0, 0, $Size, $Size)
  $backgroundPath = New-RoundedRectPath -Width $Size -Height $Size -Radius $radius

  $backgroundBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    $rect,
    [System.Drawing.Color]::Black,
    [System.Drawing.Color]::Black,
    45.0
  )
  $backgroundBlend = [System.Drawing.Drawing2D.ColorBlend]::new()
  $backgroundBlend.Colors = @(
    (Get-ArgbColor 255 181 73 34),
    (Get-ArgbColor 255 217 155 70),
    (Get-ArgbColor 255 35 17 13)
  )
  $backgroundBlend.Positions = @(0.0, 0.48, 1.0)
  $backgroundBrush.InterpolationColors = $backgroundBlend
  $Graphics.FillPath($backgroundBrush, $backgroundPath)

  $borderPen = [System.Drawing.Pen]::new((Get-ArgbColor 200 236 216 198), [single]($Size * 0.016))
  $Graphics.DrawPath($borderPen, $backgroundPath)

  $medallionRect = [System.Drawing.RectangleF]::new(
    [single]($Size * 0.2),
    [single]($Size * 0.2),
    [single]($Size * 0.6),
    [single]($Size * 0.6)
  )
  $medallionBrush = [System.Drawing.Drawing2D.PathGradientBrush]::new(
    [System.Drawing.PointF[]]@(
      [System.Drawing.PointF]::new($medallionRect.Left, $medallionRect.Top),
      [System.Drawing.PointF]::new($medallionRect.Right, $medallionRect.Top),
      [System.Drawing.PointF]::new($medallionRect.Right, $medallionRect.Bottom),
      [System.Drawing.PointF]::new($medallionRect.Left, $medallionRect.Bottom)
    )
  )
  $medallionBrush.CenterPoint = [System.Drawing.PointF]::new([single]($Size * 0.46), [single]($Size * 0.42))
  $medallionBrush.CenterColor = Get-ArgbColor 246 58 28 19
  $medallionBrush.SurroundColors = @((Get-ArgbColor 246 26 12 9))
  $Graphics.FillEllipse(
    $medallionBrush,
    $medallionRect
  )

  $outerRingBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    [System.Drawing.RectangleF]::new(
      [single]($Size * 0.14),
      [single]($Size * 0.14),
      [single]($Size * 0.72),
      [single]($Size * 0.72)
    ),
    [System.Drawing.Color]::Black,
    [System.Drawing.Color]::Black,
    90.0
  )
  $outerRingBlend = [System.Drawing.Drawing2D.ColorBlend]::new()
  $outerRingBlend.Colors = @(
    (Get-ArgbColor 214 240 197 106),
    (Get-ArgbColor 246 255 224 165),
    (Get-ArgbColor 220 240 197 106)
  )
  $outerRingBlend.Positions = @(0.0, 0.45, 1.0)
  $outerRingBrush.InterpolationColors = $outerRingBlend
  $outerRingPen = [System.Drawing.Pen]::new($outerRingBrush, [single]($Size * 0.032))
  $Graphics.DrawEllipse($outerRingPen, [single]($Size * 0.14), [single]($Size * 0.14), [single]($Size * 0.72), [single]($Size * 0.72))

  $outerRingHighlightPen = [System.Drawing.Pen]::new((Get-ArgbColor 96 255 224 165), [single]($Size * 0.01))
  $Graphics.DrawEllipse($outerRingHighlightPen, [single]($Size * 0.131), [single]($Size * 0.131), [single]($Size * 0.738), [single]($Size * 0.738))

  $innerGoldPen = [System.Drawing.Pen]::new((Get-ArgbColor 110 255 233 180), [single]($Size * 0.01))
  $Graphics.DrawEllipse(
    $innerGoldPen,
    [single]($Size * 0.165),
    [single]($Size * 0.165),
    [single]($Size * 0.67),
    [single]($Size * 0.67)
  )

  $mintRect = [System.Drawing.RectangleF]::new(
    [single]($Size * 0.187),
    [single]($Size * 0.187),
    [single]($Size * 0.626),
    [single]($Size * 0.626)
  )
  $mintBrush = [System.Drawing.Drawing2D.LinearGradientBrush]::new($mintRect, [System.Drawing.Color]::Black, [System.Drawing.Color]::Black, 90.0)
  $mintBlend = [System.Drawing.Drawing2D.ColorBlend]::new()
  $mintBlend.Colors = @(
    (Get-ArgbColor 48 98 214 196),
    (Get-ArgbColor 124 98 214 196),
    (Get-ArgbColor 48 98 214 196)
  )
  $mintBlend.Positions = @(0.0, 0.5, 1.0)
  $mintBrush.InterpolationColors = $mintBlend
  $mintPen = [System.Drawing.Pen]::new($mintBrush, [single]($Size * 0.022))
  $mintPen.StartCap = [System.Drawing.Drawing2D.LineCap]::Flat
  $mintPen.EndCap = [System.Drawing.Drawing2D.LineCap]::Flat
  $Graphics.DrawArc($mintPen, $mintRect, -143, 66)
  $Graphics.DrawArc($mintPen, $mintRect, 10, 66)

  $pillarBrush = [System.Drawing.SolidBrush]::new((Get-ArgbColor 214 240 197 106))
  $pillarRect = [System.Drawing.RectangleF]::new(
    [single]($Size * 0.46),
    [single]($Size * 0.71),
    [single]($Size * 0.08),
    [single]($Size * 0.12)
  )
  $pillarPath = New-RoundedRectPath -Width $pillarRect.Width -Height $pillarRect.Height -Radius ([single]($Size * 0.024))
  $pillarMatrix = [System.Drawing.Drawing2D.Matrix]::new()
  $pillarMatrix.Translate($pillarRect.X, $pillarRect.Y)
  $pillarPath.Transform($pillarMatrix)
  $Graphics.FillPath($pillarBrush, $pillarPath)

  $crestBrush = [System.Drawing.SolidBrush]::new((Get-ArgbColor 236 247 206 118))
  $crestPath = [System.Drawing.Drawing2D.GraphicsPath]::new()
  $crestPath.AddPolygon(
    [System.Drawing.PointF[]]@(
      [System.Drawing.PointF]::new([single]($Size * 0.5), [single]($Size * 0.17)),
      [System.Drawing.PointF]::new([single]($Size * 0.535), [single]($Size * 0.27)),
      [System.Drawing.PointF]::new([single]($Size * 0.59), [single]($Size * 0.27)),
      [System.Drawing.PointF]::new([single]($Size * 0.545), [single]($Size * 0.325)),
      [System.Drawing.PointF]::new([single]($Size * 0.5), [single]($Size * 0.295)),
      [System.Drawing.PointF]::new([single]($Size * 0.455), [single]($Size * 0.325)),
      [System.Drawing.PointF]::new([single]($Size * 0.41), [single]($Size * 0.27)),
      [System.Drawing.PointF]::new([single]($Size * 0.465), [single]($Size * 0.27))
    )
  )
  $Graphics.FillPath($crestBrush, $crestPath)

  $flameBrush = [System.Drawing.SolidBrush]::new((Get-ArgbColor 250 255 243 228))
  $flamePath = [System.Drawing.Drawing2D.GraphicsPath]::new()
  $flamePath.StartFigure()
  $flamePath.AddBezier(
    [single]($Size * 0.5), [single]($Size * 0.29),
    [single]($Size * 0.35), [single]($Size * 0.43),
    [single]($Size * 0.36), [single]($Size * 0.62),
    [single]($Size * 0.46), [single]($Size * 0.735)
  )
  $flamePath.AddBezier(
    [single]($Size * 0.46), [single]($Size * 0.735),
    [single]($Size * 0.5), [single]($Size * 0.8),
    [single]($Size * 0.54), [single]($Size * 0.735),
    [single]($Size * 0.54), [single]($Size * 0.735)
  )
  $flamePath.AddBezier(
    [single]($Size * 0.54), [single]($Size * 0.735),
    [single]($Size * 0.64), [single]($Size * 0.62),
    [single]($Size * 0.65), [single]($Size * 0.43),
    [single]($Size * 0.5), [single]($Size * 0.29)
  )
  $flamePath.CloseFigure()
  $shadowMatrix = [System.Drawing.Drawing2D.Matrix]::new()
  $shadowMatrix.Translate(0, [single]($Size * 0.02))
  $shadowPath = $flamePath.Clone()
  $shadowPath.Transform($shadowMatrix)
  $shadowBrush = [System.Drawing.SolidBrush]::new((Get-ArgbColor 46 0 0 0))
  $Graphics.FillPath($shadowBrush, $shadowPath)
  $Graphics.FillPath($flameBrush, $flamePath)

  $innerFlameBrush = [System.Drawing.SolidBrush]::new((Get-ArgbColor 236 255 224 165))
  $innerFlamePath = [System.Drawing.Drawing2D.GraphicsPath]::new()
  $innerFlamePath.StartFigure()
  $innerFlamePath.AddBezier(
    [single]($Size * 0.5), [single]($Size * 0.44),
    [single]($Size * 0.468), [single]($Size * 0.53),
    [single]($Size * 0.46), [single]($Size * 0.64),
    [single]($Size * 0.5), [single]($Size * 0.71)
  )
  $innerFlamePath.AddBezier(
    [single]($Size * 0.5), [single]($Size * 0.71),
    [single]($Size * 0.54), [single]($Size * 0.64),
    [single]($Size * 0.532), [single]($Size * 0.53),
    [single]($Size * 0.5), [single]($Size * 0.44)
  )
  $innerFlamePath.CloseFigure()
  $Graphics.FillPath($innerFlameBrush, $innerFlamePath)

  $backgroundPath.Dispose()
  $backgroundBrush.Dispose()
  $borderPen.Dispose()
  $medallionBrush.Dispose()
  $outerRingBrush.Dispose()
  $outerRingPen.Dispose()
  $outerRingHighlightPen.Dispose()
  $innerGoldPen.Dispose()
  $mintBrush.Dispose()
  $mintPen.Dispose()
  $pillarBrush.Dispose()
  $pillarPath.Dispose()
  $pillarMatrix.Dispose()
  $crestBrush.Dispose()
  $crestPath.Dispose()
  $shadowMatrix.Dispose()
  $shadowPath.Dispose()
  $shadowBrush.Dispose()
  $flameBrush.Dispose()
  $flamePath.Dispose()
  $innerFlameBrush.Dispose()
  $innerFlamePath.Dispose()
}

function Save-ScaledPng {
  param(
    [System.Drawing.Bitmap]$Source,
    [int]$Width,
    [int]$Height,
    [string]$Path
  )

  $canvas = New-Canvas -Width $Width -Height $Height
  $canvas.Graphics.DrawImage($Source, 0, 0, $Width, $Height)
  $canvas.Bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $canvas.Graphics.Dispose()
  $canvas.Bitmap.Dispose()
}

function New-AppIconIco {
  param(
    [string]$PngPath,
    [string]$IcoPath
  )

  [byte[]]$pngBytes = [System.IO.File]::ReadAllBytes($PngPath)
  $stream = [System.IO.File]::Open($IcoPath, [System.IO.FileMode]::Create)
  $writer = [System.IO.BinaryWriter]::new($stream)
  $writer.Write([UInt16]0)
  $writer.Write([UInt16]1)
  $writer.Write([UInt16]1)
  $writer.Write([byte]0)
  $writer.Write([byte]0)
  $writer.Write([byte]0)
  $writer.Write([byte]0)
  $writer.Write([UInt16]1)
  $writer.Write([UInt16]32)
  $writer.Write([UInt32]$pngBytes.Length)
  $writer.Write([UInt32]22)
  $writer.Write($pngBytes)
  $writer.Flush()
  $writer.Dispose()
  $stream.Dispose()
}

function New-BrandLogo {
  param([string]$Path)

  $canvas = New-Canvas -Width 1600 -Height 640
  $graphics = $canvas.Graphics
  $bitmap = $canvas.Bitmap
  $rect = [System.Drawing.RectangleF]::new(0, 0, 1600, 640)

  $background = [System.Drawing.Drawing2D.LinearGradientBrush]::new(
    $rect,
    [System.Drawing.Color]::Black,
    [System.Drawing.Color]::Black,
    0.0
  )
  $blend = [System.Drawing.Drawing2D.ColorBlend]::new()
  $blend.Colors = @(
    (Get-ArgbColor 255 17 10 8),
    (Get-ArgbColor 255 31 18 14),
    (Get-ArgbColor 255 68 32 24)
  )
  $blend.Positions = @(0.0, 0.62, 1.0)
  $background.InterpolationColors = $blend
  $graphics.FillRectangle($background, $rect)

  $leftGlow = [System.Drawing.SolidBrush]::new((Get-ArgbColor 34 181 73 34))
  $graphics.FillEllipse($leftGlow, 60, -20, 420, 420)

  $iconCanvas = New-Canvas -Width 360 -Height 360
  Draw-BrandCore -Graphics $iconCanvas.Graphics -Size 360
  $graphics.DrawImage($iconCanvas.Bitmap, 120, 138, 360, 360)

  $titleFont = [System.Drawing.Font]::new('Segoe UI', 72, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $subtitleFont = [System.Drawing.Font]::new('Segoe UI', 26, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $captionFont = [System.Drawing.Font]::new('Segoe UI', 22, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $whiteBrush = [System.Drawing.SolidBrush]::new((Get-ArgbColor 246 255 243 230))
  $goldBrush = [System.Drawing.SolidBrush]::new((Get-ArgbColor 236 240 197 106))
  $mutedBrush = [System.Drawing.SolidBrush]::new((Get-ArgbColor 198 220 204 191))

  $graphics.DrawString('EMBER', $titleFont, $whiteBrush, 538, 174)
  $graphics.DrawString('PARTY CLUB', $titleFont, $whiteBrush, 538, 258)
  $graphics.DrawString('CLUB BADGE BRAND SYSTEM', $subtitleFont, $goldBrush, 542, 362)
  $graphics.DrawString('EMBER CORE  GOLD CREST  PRIVATE ROOM CLUB', $captionFont, $mutedBrush, 544, 408)

  $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)

  $background.Dispose()
  $leftGlow.Dispose()
  $iconCanvas.Graphics.Dispose()
  $iconCanvas.Bitmap.Dispose()
  $titleFont.Dispose()
  $subtitleFont.Dispose()
  $captionFont.Dispose()
  $whiteBrush.Dispose()
  $goldBrush.Dispose()
  $mutedBrush.Dispose()
  $graphics.Dispose()
  $bitmap.Dispose()
}

function New-BrandWordmark {
  param([string]$Path)

  $canvas = New-Canvas -Width 1400 -Height 360
  $graphics = $canvas.Graphics
  $bitmap = $canvas.Bitmap

  $graphics.Clear([System.Drawing.Color]::Transparent)

  $iconCanvas = New-Canvas -Width 260 -Height 260
  Draw-BrandCore -Graphics $iconCanvas.Graphics -Size 260
  $graphics.DrawImage($iconCanvas.Bitmap, 16, 50, 260, 260)

  $titleFont = [System.Drawing.Font]::new('Segoe UI', 60, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $subtitleFont = [System.Drawing.Font]::new('Segoe UI', 22, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
  $captionFont = [System.Drawing.Font]::new('Segoe UI', 18, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
  $whiteBrush = [System.Drawing.SolidBrush]::new((Get-ArgbColor 248 255 244 232))
  $goldBrush = [System.Drawing.SolidBrush]::new((Get-ArgbColor 236 240 197 106))
  $mutedBrush = [System.Drawing.SolidBrush]::new((Get-ArgbColor 214 221 208 198))

  $graphics.DrawString('EMBER', $titleFont, $whiteBrush, 316, 82)
  $graphics.DrawString('PARTY CLUB', $titleFont, $whiteBrush, 316, 152)
  $graphics.DrawString('CLUB BADGE BRAND SYSTEM', $subtitleFont, $goldBrush, 320, 242)
  $graphics.DrawString('EMBER CORE  GOLD CREST  PRIVATE ROOM CLUB', $captionFont, $mutedBrush, 322, 282)

  $bitmap.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)

  $iconCanvas.Graphics.Dispose()
  $iconCanvas.Bitmap.Dispose()
  $titleFont.Dispose()
  $subtitleFont.Dispose()
  $captionFont.Dispose()
  $whiteBrush.Dispose()
  $goldBrush.Dispose()
  $mutedBrush.Dispose()
  $graphics.Dispose()
  $bitmap.Dispose()
}

New-DirectoryIfMissing -Path (Join-Path $projectRoot 'assets\branding')
New-DirectoryIfMissing -Path (Join-Path $projectRoot 'web\branding')

$iconCanvas = New-Canvas -Width 1024 -Height 1024
Draw-BrandCore -Graphics $iconCanvas.Graphics -Size 1024
$iconPath = Join-Path $projectRoot 'assets\branding\ember_app_icon.png'
$iconCanvas.Bitmap.Save($iconPath, [System.Drawing.Imaging.ImageFormat]::Png)

$logoPath = Join-Path $projectRoot 'assets\branding\ember_logo.png'
New-BrandLogo -Path $logoPath
$wordmarkPath = Join-Path $projectRoot 'assets\branding\ember_wordmark.png'
New-BrandWordmark -Path $wordmarkPath
$wordmarkBitmap = [System.Drawing.Bitmap]::new($wordmarkPath)

$androidSizes = @{
  'mipmap-mdpi\ic_launcher.png' = 48
  'mipmap-hdpi\ic_launcher.png' = 72
  'mipmap-xhdpi\ic_launcher.png' = 96
  'mipmap-xxhdpi\ic_launcher.png' = 144
  'mipmap-xxxhdpi\ic_launcher.png' = 192
}
foreach ($relativePath in $androidSizes.Keys) {
  $targetPath = Join-Path $projectRoot ("android\app\src\main\res\" + $relativePath)
  Save-ScaledPng -Source $iconCanvas.Bitmap -Width $androidSizes[$relativePath] -Height $androidSizes[$relativePath] -Path $targetPath
}

$androidLaunchSizes = @(
  @{ Dir = 'drawable-mdpi'; Width = 280; Height = 72 },
  @{ Dir = 'drawable-hdpi'; Width = 420; Height = 108 },
  @{ Dir = 'drawable-xhdpi'; Width = 560; Height = 144 },
  @{ Dir = 'drawable-xxhdpi'; Width = 840; Height = 216 },
  @{ Dir = 'drawable-xxxhdpi'; Width = 1120; Height = 288 }
)
foreach ($item in $androidLaunchSizes) {
  $targetDir = Join-Path $projectRoot ("android\app\src\main\res\" + $item.Dir)
  New-DirectoryIfMissing -Path $targetDir
  $targetPath = Join-Path $targetDir 'launch_wordmark.png'
  Save-ScaledPng -Source $wordmarkBitmap -Width $item.Width -Height $item.Height -Path $targetPath
}

$iosSizes = @(
  @{ File = 'Icon-App-20x20@1x.png'; Size = 20 },
  @{ File = 'Icon-App-20x20@2x.png'; Size = 40 },
  @{ File = 'Icon-App-20x20@3x.png'; Size = 60 },
  @{ File = 'Icon-App-29x29@1x.png'; Size = 29 },
  @{ File = 'Icon-App-29x29@2x.png'; Size = 58 },
  @{ File = 'Icon-App-29x29@3x.png'; Size = 87 },
  @{ File = 'Icon-App-40x40@1x.png'; Size = 40 },
  @{ File = 'Icon-App-40x40@2x.png'; Size = 80 },
  @{ File = 'Icon-App-40x40@3x.png'; Size = 120 },
  @{ File = 'Icon-App-60x60@2x.png'; Size = 120 },
  @{ File = 'Icon-App-60x60@3x.png'; Size = 180 },
  @{ File = 'Icon-App-76x76@1x.png'; Size = 76 },
  @{ File = 'Icon-App-76x76@2x.png'; Size = 152 },
  @{ File = 'Icon-App-83.5x83.5@2x.png'; Size = 167 },
  @{ File = 'Icon-App-1024x1024@1x.png'; Size = 1024 }
)
foreach ($item in $iosSizes) {
  $targetPath = Join-Path $projectRoot ("ios\Runner\Assets.xcassets\AppIcon.appiconset\" + $item.File)
  Save-ScaledPng -Source $iconCanvas.Bitmap -Width $item.Size -Height $item.Size -Path $targetPath
}

$iosLaunchSizes = @(
  @{ File = 'LaunchImage.png'; Width = 280; Height = 72 },
  @{ File = 'LaunchImage@2x.png'; Width = 560; Height = 144 },
  @{ File = 'LaunchImage@3x.png'; Width = 840; Height = 216 }
)
foreach ($item in $iosLaunchSizes) {
  $targetPath = Join-Path $projectRoot ("ios\Runner\Assets.xcassets\LaunchImage.imageset\" + $item.File)
  Save-ScaledPng -Source $wordmarkBitmap -Width $item.Width -Height $item.Height -Path $targetPath
}

$macSizes = @(
  @{ File = 'app_icon_16.png'; Size = 16 },
  @{ File = 'app_icon_32.png'; Size = 32 },
  @{ File = 'app_icon_64.png'; Size = 64 },
  @{ File = 'app_icon_128.png'; Size = 128 },
  @{ File = 'app_icon_256.png'; Size = 256 },
  @{ File = 'app_icon_512.png'; Size = 512 },
  @{ File = 'app_icon_1024.png'; Size = 1024 }
)
foreach ($item in $macSizes) {
  $targetPath = Join-Path $projectRoot ("macos\Runner\Assets.xcassets\AppIcon.appiconset\" + $item.File)
  Save-ScaledPng -Source $iconCanvas.Bitmap -Width $item.Size -Height $item.Size -Path $targetPath
}

$webAssets = @(
  @{ File = 'web\favicon.png'; Size = 64; Maskable = $false },
  @{ File = 'web\icons\Icon-192.png'; Size = 192; Maskable = $false },
  @{ File = 'web\icons\Icon-512.png'; Size = 512; Maskable = $false },
  @{ File = 'web\icons\Icon-maskable-192.png'; Size = 192; Maskable = $true },
  @{ File = 'web\icons\Icon-maskable-512.png'; Size = 512; Maskable = $true }
)
foreach ($item in $webAssets) {
  $targetPath = Join-Path $projectRoot $item.File
  if ($item.Maskable) {
    $maskCanvas = New-Canvas -Width $item.Size -Height $item.Size
    Draw-BrandCore -Graphics $maskCanvas.Graphics -Size $item.Size -Maskable $true
    $maskCanvas.Bitmap.Save($targetPath, [System.Drawing.Imaging.ImageFormat]::Png)
    $maskCanvas.Graphics.Dispose()
    $maskCanvas.Bitmap.Dispose()
  } else {
    Save-ScaledPng -Source $iconCanvas.Bitmap -Width $item.Size -Height $item.Size -Path $targetPath
  }
}

Save-ScaledPng -Source $wordmarkBitmap -Width 700 -Height 180 -Path (Join-Path $projectRoot 'web\branding\ember_wordmark.png')
Save-ScaledPng -Source $iconCanvas.Bitmap -Width 192 -Height 192 -Path (Join-Path $projectRoot 'web\branding\ember_app_icon.png')

$windowsPng = Join-Path $projectRoot 'windows\runner\resources\app_icon_256.png'
Save-ScaledPng -Source $iconCanvas.Bitmap -Width 256 -Height 256 -Path $windowsPng
New-AppIconIco -PngPath $windowsPng -IcoPath (Join-Path $projectRoot 'windows\runner\resources\app_icon.ico')
Remove-Item -LiteralPath $windowsPng

$wordmarkBitmap.Dispose()
$iconCanvas.Graphics.Dispose()
$iconCanvas.Bitmap.Dispose()

Write-Host 'Brand assets generated successfully.'
