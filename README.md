# 🖼️ JPEG Optimizer and Tagger
## 📝 Description
An intelligent bash script that optimizes JPEG images while maintaining image quality and tags them for future reference. The script uses jpegtran for lossless compression and exiftool for metadata management. 🚀

## ✨ Key Features
🔍 Recursive search for JPG/JPEG files

📊 Lossless image optimization

🏷️ Smart metadata tagging

🔄 Iterative optimization process

⚡ Keeps only the smallest optimized version

🎯 Skips already optimized images

## 🔧 Prerequisites

### For Debian/Ubuntu
```bash
sudo apt-get install libjpeg-progs libimage-exiftool-perl
```
### For Fedora
```bash
sudo dnf install libjpeg-turbo-utils perl-Image-ExifTool
```
## 🚀 Usage
```bash
./jpeg_optimizer
```

## ⚙️ Process Flow
🔍 Finds all .jpg/.jpeg files

✨ Checks for 'Optimized' tag

📦 Performs lossless optimization

🏷️ Tags processed images

💾 Keeps smallest version

## ⚠️ Notes
Requires write permissions

Creates temporary files during processing

Non-destructive optimization

Preserves original metadata
