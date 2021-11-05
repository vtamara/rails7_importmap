require "application_system_test_case"

class PublicacionesTest < ApplicationSystemTestCase
  setup do
    @publicacion = publicaciones(:one)
  end

  test "visiting the index" do
    visit publicaciones_url
    assert_selector "h1", text: "Publicaciones"
  end

  test "should create Publicacion" do
    visit publicaciones_url
    click_on "New Publicacion"

    fill_in "Contenido", with: @publicacion.contenido
    fill_in "Titulo", with: @publicacion.titulo
    click_on "Create Publicacion"

    assert_text "Publicacion was successfully created"
    click_on "Back"
  end

  test "should update Publicacion" do
    visit publicaciones_url
    click_on "Edit", match: :first

    fill_in "Contenido", with: @publicacion.contenido
    fill_in "Titulo", with: @publicacion.titulo
    click_on "Update Publicacion"

    assert_text "Publicacion was successfully updated"
    click_on "Back"
  end

  test "should destroy Publicacion" do
    visit publicaciones_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Publicacion was successfully destroyed"
  end
end
