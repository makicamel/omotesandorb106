@default_foreground ||= '#333333'
@default_background ||= @background

@base_color            = '#333333'
accent_color           = '#dd451d'
@default_font          = 'Gen Jyuu Gothic P'
@font_family           = find_font_family(@default_font)
@bold_font             = 'Gen Jyuu Gothic P Bold'
@bold_font_family      = find_font_family(@bold_font)
@monospace_font        = 'Space Mono'
@monospace_font_family = find_font_family(@monospace_font)
@preformatted_fill_color = "green"

@default_item1_mark_color = accent_color
@default_item2_mark_color = accent_color

@xxxx_large_font_size = screen_size(10 * Pango::SCALE)
@xxx_large_font_size  = screen_size(8 * Pango::SCALE)
@xx_large_font_size   = screen_size(6 * Pango::SCALE)
@x_large_font_size    = screen_size(4.5 * Pango::SCALE)
@large_font_size      = screen_size(4 * Pango::SCALE)
@normal_font_size     = screen_size(3.5 * Pango::SCALE)
@small_font_size      = screen_size(3.2 * Pango::SCALE)
@x_small_font_size    = screen_size(3 * Pango::SCALE)
@xx_small_font_size   = screen_size(2.0 * Pango::SCALE)
@xxx_small_font_size  = @xx_small_font_size
@script_font_size            = @x_small_font_size
@large_script_font_size      = @small_font_size
@x_large_script_font_size    = @large_font_size
@title_slide_title_font_size = @xxx_large_font_size

@block_quote_fill_color = '#f8f8f8'
@preformatted_fill_color = '#f8f8f8'
@description_term_line_color = accent_color
@default_headline_line_color = "#fce9e5"
@default_headline_line_width = 0
@default_headline_line_expand = true

@title_slide_background_image = 'image/title_background.png'

@default_emphasis_color = accent_color

@foot_text_block_line_width = 0

include_theme('default')
include_theme('default-block-quote')
include_theme('default-description')
include_theme('default-icon')
include_theme('default-method-list')
include_theme('default-preformatted')
include_theme('default-text')
include_theme('default-title-text')
include_theme('default-title-slide')

include_theme('background-image-toolkit')
include_theme('body-background-image')
include_theme('newline-in-slides')
include_theme('image')
include_theme('per-slide-background-color')
include_theme('per-slide-background-image')
include_theme('simple-item-mark')
include_theme('syntax-highlighting')
include_theme('title-slide-background-image')
include_theme('table')
include_theme('tag')

@lightning_talk_proc_name = 'lightning-rabbit'
include_theme('lightning-talk-toolkit')

match(Slide, HeadLine) do |slides|
  draw_rounded_frame = Proc.new do |targets, name|


      targets.delete_pre_draw_proc_by_name(name)
      targets.add_pre_draw_proc(name) do |slide, canvas, x, y, w, h, _simulation|

        rx, ry = screen_x(1.6), screen_y(3)
        rw, rh = canvas.width - rx * 2, ry * 3.2
        radius = screen_x(1)
        if slide.text != "　　" && slide.text != "We're hiring!"
          canvas.draw_rounded_rectangle(true, rx, ry, rw, rh, radius, @default_headline_line_color)
        end
        [x, y, w, h]
      end
    end

    draw_rounded_frame.call(slides, "slide")
end

match(TitleSlide) do |slides|
  slides.vertical_centering = true
  slides.prop_set('weight', 'bold')
end
match(TitleSlide, Title) do |titles|
  titles.padding_top = @space * 8
  titles.margin_right = @space * 12
  titles.margin_left = @space * 12
  titles.prop_set('size', @xxx_large_font_size)
  titles.prop_set('weight', 'bold')
end
match(TitleSlide, Author) do |author|
  author.padding_top = @space * 4
  author.margin_top = 80
  author.margin_bottom = 0
  author.vertical_centering = true
  author.prop_set('weight', 'normal')
end
match(TitleSlide, Date) do |date|
  date.margin_top = 4
  date.prop_set('weight', 'normal')
end
match(TitleSlide, ContentSource) do |cs|
  cs.margin_top = 4
  cs.prop_set('weight', 'normal')
end
match(TitleSlide, '*') do |elems|
  elems.prop_set('style', 'normal')
end
match(Slide, HeadLine) do |heads|
  heads.margin_top = 4
  heads.padding_bottom = 20
  heads.prop_set('size', @x_large_font_size)
  heads.prop_set('weight', 'SemiBold')
end

match('**', ReferText) do |texts|
  texts.prop_set('foreground', accent_color)
  texts.prop_set('size', @xxx_small_font_size)
end

# 脚注参照番号
match('**', Footnote) do
  prop_set('foreground', @base_color)
  each do |note|
    note.text = "[^#{note.order}]"
    note.prop_set('size', @xxx_small_font_size)
    note.prop_set('rise', (@normal_font_size * 3 / 5.0).to_i)
  end
end
# 脚注本体番号
match('**', FootText) do
  each do |text|
    if text['order_added']
      order_text = text.elements.first
      order_text.text = text.elements.first.text.sub(%r{\(\*(\d+)\)}) { "[^#{$1}]: " }
      order_text.prop_set('rise', (@xxx_small_font_size * 1 / 10.0).to_i)
      order_text.prop_set('foreground', @base_color)
      order_text.prop_set('size', @xxx_small_font_size)
    end
  end
end
# 脚注本体
match('**', FootTextBlock) do |text_block|
  text_block.margin_bottom = 0
  text_block.margin_left = 60
  text_block.prop_set('size', @xxx_small_font_size)
end

match(Slide) do |slides|
  slides.each do |slide|
    if slide.lightning_talk?
      slide.lightning_talk
    end
  end
end

pp 'reloaded!'
