require_relative '../lib/utils'

describe "the get_page method" do
  it "should return page, and page is not nil" do
    expect(get_page("https://www.google.com")).not_to be_nil
  end

  it "should return nil if the \"url_to_scrap\" argument is nil either is NOT a nonempty String or if this URL can't be found" do
    expect(get_page(nil)).to eq(nil)
    expect(get_page([])).to eq(nil)
    expect(get_page({})).to eq(nil)
    expect(get_page("")).to eq(nil)
    expect(get_page("   ")).to eq(nil)
    expect(get_page("http://www.ma_page_sur_Toto.fr")).to eq(nil)
    expect(get_page('127.0.0.1')).to eq(nil)
    expect(get_page("ma_page_sur_Toto.html")).to eq(nil)
  end
end
     
