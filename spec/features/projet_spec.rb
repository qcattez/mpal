require 'rails_helper'
require 'support/mpal_helper'
require 'support/api_particulier_helper'
require 'support/api_ban_helper'

feature "Projet" do
  let(:projet) { FactoryGirl.create(:projet) }

  scenario "affichage de mon projet" do
    signin(projet.numero_fiscal, projet.reference_avis)
    visit projet_path(projet)
    expect(page).to have_content("Martin")
  end

  scenario "correction de mon adresse" do
    signin(projet.numero_fiscal, projet.reference_avis)
    click_link I18n.t('projets.visualisation.lien_edition_projet', match: :first)
    fill_in :projet_adresse, with: '12 rue de la mare, 75010 Paris'
    click_button I18n.t('projets.edition.action')
    expect(page).to have_content('12 rue de la Mare, 75010 Paris')
  end

  scenario "correction de l'année de construction de mon logement" do
    signin(projet.numero_fiscal, projet.reference_avis)
    click_link I18n.t('projets.visualisation.lien_edition_projet')
    fill_in :projet_annee_construction, with: '1950'
    click_button I18n.t('projets.edition.action')
    expect(page).to have_content(1950)
  end

  scenario "lorsque je suis un demandeur, je vois les informations me concernant" do
    signin(projet.numero_fiscal, projet.reference_avis)
    @role_utilisateur = :demandeur
    expect(page).to have_content('Mes infos')
  end

  scenario "l'ajout d'une adresse e-mail non conforme affiche un message d'erreur" do
    signin(projet.numero_fiscal, projet.reference_avis)
    click_link I18n.t('projets.visualisation.lien_edition_projet')
    fill_in :projet_email, with: "lolo"
    click_button I18n.t('projets.edition.action')
    expect(page).to have_content(I18n.t('projets.edition_projet.messages.erreur_email_invalide'))
  end

  scenario "choisit un opérateur qui a été invité" do
    operateur = FactoryGirl.create(:intervenant, :operateur)
    invitation = FactoryGirl.create(:invitation, intervenant: operateur)
    projet = invitation.projet
    signin(projet.numero_fiscal, projet.reference_avis)
    visit projet_intervenants_path(projet)
    expect(page).to have_content(invitation.intervenant.raison_sociale)
    click_link I18n.t('projets.visualisation.choisir_intervenant')
    expect(page).to have_content(I18n.t('choix_intervenants.nouveau.explication'))
    click_button I18n.t('choix_intervenants.nouveau.action')
    expect(page).to have_content(I18n.t('projets.intervenants.messages.succes_choix_intervenant'))
    within '.choisi' do
      expect(page).to have_content(operateur.raison_sociale) 
    end
  end

  scenario "lorsque je suis un demandeur, je peux saisir des montants sur mon plan de financement" do
    signin(projet.numero_fiscal, projet.reference_avis)
    @role_utilisateur = :demandeur
    visit projet_demande_path(projet)
    expect(page).to have_content(I18n.t('projets.demande.plan_financement'))
    expect(page).to have_content(Aide.first.libelle)
  end

end
