describe('CRUD Inventory', () => {

    beforeEach(() => {

        cy.visit('https://app.blockcode.site/')

        // LOGIN
        cy.get('input[type="email"]')
            .type('admin@admin.com')

        cy.get('input[type="password"]')
            .type('1234@abc')

        cy.contains('Sign in')
            .click()

        cy.url({ timeout: 15000 })
            .should('not.include', '/login')

        cy.wait(3000)

        cy.visit('https://app.blockcode.site/dashboard/inventory')

        cy.wait(3000)

    })

    it('Crear recurso', () => {

        cy.get('select')
            .select(1)

        cy.get('input[placeholder="Resource"]')
            .type('Cemento Cypress')

        cy.get('input[placeholder="Quantity"]')
            .type('100')

        cy.get('input[placeholder="Status"]')
            .type('Disponible')

        cy.contains('Create')
            .click()

        cy.get('.modal-popup', { timeout: 10000 })
            .should('be.visible')

        cy.get('.btn-confirm')
            .click()

        cy.contains('Cemento Cypress', { timeout: 10000 })
            .should('exist')

    })

    it('Editar recurso', () => {

        cy.contains('td', 'Cemento Cypress')
            .parent()
            .find('.btn-edit')
            .click()

        cy.get('input[placeholder="Quantity"]')
            .clear()
            .type('200')

        cy.contains('Update')
            .click()

        cy.get('.modal-popup')
            .should('be.visible')

        cy.get('.btn-confirm')
            .click()

        cy.contains('td', '200')
            .should('exist')

    })

    it('Eliminar recurso', () => {

        cy.contains('td', 'Cemento Cypress')
            .parent()
            .find('.btn-delete')
            .click()

        cy.get('.modal-popup')
            .should('be.visible')

        cy.get('.btn-confirm')
            .click()

        cy.contains('td', 'Cemento Cypress')
            .should('not.exist')

    })

})