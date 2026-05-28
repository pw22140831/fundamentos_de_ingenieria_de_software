describe('Login Blockcode', () => {

  it('Inicia sesión correctamente', () => {

    cy.visit('https://app.blockcode.site/')

    cy.get('input[type="email"]')
      .type('admin@admin.com')

    cy.get('input[type="password"]')
      .type('1234@abc')

    cy.contains('Sign in')
      .click()

  })

})