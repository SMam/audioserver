# coding: utf-8
require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the AudiogramsHelper. For example:
#
# describe AudiogramsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe AudiogramsHelper do
  describe "reg_id" do
    it "xxxx-xxx-xx-xの形式に変換されること" do
      reg_id("19").should == "000-0000-01-9"
    end

    it "10桁を越える入力の場合、11桁目以降は捨てること" do
      reg_id("1234567890123").should == "123-4567-89-0"
    end
  end

  describe "mean" do
    def set_data_with_round(r, l)
      return {:R => (r * 10.0).round / 10.0, :L => (l * 10.0).round / 10.0}
    end

    context "dataが全て揃っている場合" do
      before do
        @audiogram = FactoryGirl.create(:audiogram)
        #    500  1k  2k  4k
        # Rt  10  20  30  40
        # Lt  15  25  30  45
        @a = [@audiogram.ac_rt_500, @audiogram.ac_rt_1k,  @audiogram.ac_rt_2k,\
	      @audiogram.ac_rt_4k,  @audiogram.ac_lt_500, @audiogram.ac_lt_1k,\
	      @audiogram.ac_lt_2k, @audiogram.ac_lt_4k]
      end
    
      it "3分法が正しく求められること" do
        r3 = (@a[0] + @a[1] + @a[2]) / 3
        l3 = (@a[4] + @a[5] + @a[6]) / 3
        mean("3",@audiogram).should == set_data_with_round(r3, l3)
      end

      it "4分法が正しく求められること" do
        r4 = (@a[0] + @a[1] *2 + @a[2]) / 4
        l4 = (@a[4] + @a[5] *2 + @a[6]) / 4
        mean("4",@audiogram).should == set_data_with_round(r4, l4)
      end

      it "6分法が正しく求められること" do
        r6 = (@a[0] + @a[1] *2 + @a[2] *2 + @a[3]) / 6
        l6 = (@a[4] + @a[5] *2 + @a[6] *2 + @a[7]) / 6
        mean("6",@audiogram).should == set_data_with_round(r6, l6)
      end

      it "正規化4分法が正しく求められること(100dBを超えるデータの取扱い)" do
        @audiogram.ac_rt_1k = 110.0
        @a[1] = 105.0     # cut off された数値
        @audiogram.ac_lt_2k = 110.0
        @a[6] = 105.0     # cut off された数値
        r4r = (@a[0] + @a[1] *2 + @a[2]) / 4
        l4r = (@a[4] + @a[5] *2 + @a[6]) / 4
        mean("4R",@audiogram).should == set_data_with_round(r4r, l4r)
      end
    end

    context "dataが欠損している場合" do
      before do
        @audiogram = FactoryGirl.create(:audiogram, :ac_rt_1k => nil, :ac_lt_2k => nil)
        #    500  1k  2k  4k
        # Rt  10  --  30  40
        # Lt  15  25  --  45
      end
    
      it "3分法の結果として -- を返すこと" do
        mean("3",@audiogram).should == {:R => "--", :L => "--"}
      end

      it "4分法の結果として -- を返すこと" do
        mean("4",@audiogram).should == {:R => "--", :L => "--"}
      end

      it "6分法の結果として -- を返すこと" do
        mean("6",@audiogram).should == {:R => "--", :L => "--"}
      end

      it "正規化4分法の結果として -- を返すこと" do
        mean("4R",@audiogram).should == {:R => "--", :L => "--"}
      end
    end
  end
end
