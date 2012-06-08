require "spec_helper"

describe "About -" do

  context "displaying profile's information -" do
    before do
      visit "/"
      click_link "Sobre"
    end

    it "should redirects to the about page -" do
      current_path.should eql(about_path)
    end

     it "should show the author's bio -" do
       page.should have_content("Desenvolvedor Java, Ruby e Python no Portal <a href=\"http://r7.com\" target=\"_blank\">R7.com</a>.\nÉ Baicharel em Sistemas de Informação e certificado OCJA 1.0 e OCJP 6.\nAjudante e aprendiz da comunidade open source e metido a designer.\n Além disso é apaixonado pela dança, skate, jiu-jitsu e Counter Strike Source. (:")
     end
  end

end
