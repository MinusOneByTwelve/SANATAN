from PIL import Image, ImageDraw, ImageFont

main_text = "THEREQHEADER"
font = "THEREQFONT"
saveloc = "THEREQLOC"
width, height = 155, 55
bgcolor = "#065986"
main_text_color = "white"
sub_text = "===== VAMANA ====="
sub_text_color = "white"
image = Image.new('RGB', (width, height), color = bgcolor)
draw = ImageDraw.Draw(image)
main_font = ImageFont.truetype(font, 18)
small_font = ImageFont.truetype(font, 10)
main_bbox = draw.textbbox((0, 0), main_text, font=main_font)
main_text_width = main_bbox[2] - main_bbox[0]
main_text_height = main_bbox[3] - main_bbox[1]
main_x = (width - main_text_width) / 2
main_y = (height - main_text_height) / 2 - 5
draw.text((main_x, main_y), main_text, font=main_font, fill=main_text_color)
sub_bbox = draw.textbbox((0, 0), sub_text, font=small_font)
sub_text_width = sub_bbox[2] - sub_bbox[0]
sub_text_height = sub_bbox[3] - sub_bbox[1]
sub_x = (width - sub_text_width) / 2
sub_y = main_y + main_text_height + 10
draw.text((sub_x, sub_y), sub_text, font=small_font, fill=sub_text_color)
image.save(saveloc)
