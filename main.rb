require "dxopal"
include DXOpal

# canvasのサイズ
Window.width = 640
Window.height = 480
# リングの座標とタワーの持つリング
@r_position = [[50,350,120],[40,370,140],[30,390,160],[20,410,180],[10,430,200]]
@tower_nomber = [[1,1,1,1,1],[0,0,0,0,0],[0,0,0,0,0]]
@t_index_temp = 0
@heighest_ring_no = 0

# ゲームの状態を記憶するハッシュを追加
GAME_INFO = {
  scene: :title,  # 現在のシーン(起動直後は:title)
  score: 0,
}

# リングを表すクラスを定義
class Ring < Sprite
  def initialize(x_l, y_l, sizex, sizey,color)
    size_x = sizex
    size_y = sizey
    x= x_l
    y = y_l
    @img_normal = Image.new(sizex, sizey)
    @img_normal.box_fill(0, 0, 200, 20, color)
    super(x, y, @img_normal)
  end
end
# クラスここまで

def overwrite_r_position
  if Input.mouse_push?(1)
    # y=100がある場合
    if @r_position.find{|n| n[1]==100} != nil
      if Input.mouse_x < Window.width/3 && (@tower_nomber[0].index(1).nil? || @heighest_ring_no < @tower_nomber[0].index(1))
        @r_position[@heighest_ring_no][0] = (UT_mergin+UT_width+10)/2 - @r_position[@heighest_ring_no][2]/2
        @r_position[@heighest_ring_no][1] = 430-20*@tower_nomber[0].sum
        @tower_nomber[0][@heighest_ring_no] = 1
        GAME_INFO[:score] += 1
        puts @heighest_ring_no
        puts @tower_nomber
      elsif Input.mouse_x >= Window.width/3 && Input.mouse_x <= Window.width/3*2 && (@tower_nomber[1].index(1).nil? || @heighest_ring_no < @tower_nomber[1].index(1))
        @r_position[@heighest_ring_no][0] = Window.width/2 - @r_position[@heighest_ring_no][2]/2
        @r_position[@heighest_ring_no][1] = 430-20*@tower_nomber[1].sum
        @tower_nomber[1][@heighest_ring_no] = 1
        GAME_INFO[:score] += 1
        puts @heighest_ring_no
        puts @tower_nomber
      elsif Input.mouse_x >= Window.width/3*2 && (@tower_nomber[2].index(1).nil? || @heighest_ring_no < @tower_nomber[2].index(1))
        @r_position[@heighest_ring_no][0] = (UT_width*5+UT_mergin*6)/2 - @r_position[@heighest_ring_no][2]/2
        @r_position[@heighest_ring_no][1] = 430-20*@tower_nomber[2].sum
        @tower_nomber[2][@heighest_ring_no] = 1
        GAME_INFO[:score] += 1
        puts @heighest_ring_no
        puts @tower_nomber
      end
    # y=100がない場合
    else
      if Input.mouse_x < Window.width/3 && @tower_nomber[0].index(1) != nil
        @t_index_temp = 0
        @heighest_ring_no = @tower_nomber[@t_index_temp].index(1)
        @r_position[@heighest_ring_no][1] = 100
        @tower_nomber[0][@heighest_ring_no] = 0
      elsif (Input.mouse_x >= Window.width/3 && Input.mouse_x <= Window.width/3*2) && @tower_nomber[1].index(1) != nil
        @t_index_temp = 1
        @heighest_ring_no = @tower_nomber[@t_index_temp].index(1)
        @r_position[@heighest_ring_no][1] = 100
        @tower_nomber[1][@heighest_ring_no] = 0
      elsif Input.mouse_x >= Window.width/3*2 && @tower_nomber[2].index(1) != nil
        @t_index_temp = 2
        @heighest_ring_no = @tower_nomber[@t_index_temp].index(1)
        @r_position[@heighest_ring_no][1] = 100
        @tower_nomber[2][@heighest_ring_no] = 0
      end
    end
  end
end

def position_update
  @ring0.x, @ring0.y = @r_position[0][0], @r_position[0][1]
  @ring1.x, @ring1.y = @r_position[1][0], @r_position[1][1]
  @ring2.x, @ring2.y = @r_position[2][0], @r_position[2][1]
  @ring3.x, @ring3.y = @r_position[3][0], @r_position[3][1]
  @ring4.x, @ring4.y = @r_position[4][0], @r_position[4][1]
end

# クラスここまで
def clear_game?
  if @tower_nomber[2].sum == 5
    GAME_INFO[:scene] = :clear
  end
end

UT_width = (Window.width-40)/3
UT_height = 10
UT_mergin = 10

Window.load_resources do
  # Playerクラスのオブジェクトを作る
  @ring4 = Ring.new(10,430,200,20,C_RED)
  @ring3 = Ring.new(20,410,180,20,C_GREEN)
  @ring2 = Ring.new(30,390,160,20,C_BLACK)
  @ring1 = Ring.new(40,370,140,20,C_YELLOW)
  @ring0 = Ring.new(50,350,120,20,C_BLUE)
  # Itemsクラスのオブジェクトを作る

  Window.loop do
    # 背景とスコア表示は、どの画面でも出すことにする
    Window.draw_box_fill(0 , 0, 640, 480, [133, 133, 133])
    Window.draw_box_fill(10 , 450, UT_mergin+UT_width, 450+UT_height, [255, 255, 255])
    Window.draw_box_fill((UT_mergin+UT_width+10)/2-5 , 250, (UT_mergin+UT_width+10)/2+5, 450, [255, 255, 255])

    Window.draw_box_fill(UT_width+UT_mergin*2 , 450, UT_width*2+UT_mergin*2, 450+UT_height, [255, 255, 255])
    Window.draw_box_fill(Window.width/2-5 , 250, Window.width/2+5, 450, [255, 255, 255])

    Window.draw_box_fill(UT_width*2+UT_mergin*3 , 450, UT_width*3+UT_mergin*3 , 450+UT_height, [255, 255, 255])
    Window.draw_box_fill((UT_width*5+UT_mergin*6)/2-5 , 250, (UT_width*5+UT_mergin*6)/2+5, 450, [255, 255, 255])

    @ring4.draw
    @ring3.draw
    @ring2.draw
    @ring1.draw
    @ring0.draw
    # シーンごとの処理
    case GAME_INFO[:scene]
    when :title
      # タイトル画面
      Window.draw_font(Window.width/2-120, Window.height/2-100, "スペースキーでスタート", Font.default)
      # スペースキーが押されたらシーンを変える
      if Input.key_push?(K_SPACE)
        GAME_INFO[:scene] = :playing
      end
    when :playing
      # ゲーム中
      Window.draw_font(0, 0, "COUNT: #{GAME_INFO[:score]}", Font.default)
      Window.draw_font(0, 30, "スペースキーで最初に戻る", Font.default)
      @ring4.draw
      @ring3.draw
      @ring2.draw
      @ring1.draw
      @ring0.draw
      overwrite_r_position
      position_update
      clear_game?
      # スペースキーが押されたらゲームの状態をリセットし、シーンを変える
      if Input.key_push?(K_SPACE)
        GAME_INFO[:score] = 0
        GAME_INFO[:scene] = :playing
        @r_position = [[50,350,120],[40,370,140],[30,390,160],[20,410,180],[10,430,200]]
        @tower_nomber = [[1,1,1,1,1],[0,0,0,0,0],[0,0,0,0,0]]
      end

    when :clear
      # ゲームクリア画面
      Window.draw_font(0, 0, "COUNT: #{GAME_INFO[:score]}", Font.default)
      Window.draw_font(Window.width/2-120, Window.height/2-120, "おめでとうございます！", Font.default)
      Window.draw_font(Window.width/2-120, Window.height/2-70, "#{GAME_INFO[:score]}手でクリアしました！", Font.default)
      Window.draw_font(Window.width/2-140, Window.height/2-20, "最小手数まであと#{GAME_INFO[:score]-31}手です！", Font.default)
      Window.draw_font(0, 30, "スペースキーで最初に戻る", Font.default)
      # スペースキーが押されたらゲームの状態をリセットし、シーンを変える
      if Input.key_push?(K_SPACE)
        GAME_INFO[:score] = 0
        GAME_INFO[:scene] = :playing
        @r_position = [[50,350,120],[40,370,140],[30,390,160],[20,410,180],[10,430,200]]
        @tower_nomber = [[1,1,1,1,1],[0,0,0,0,0],[0,0,0,0,0]]
      end
    end
  end
end