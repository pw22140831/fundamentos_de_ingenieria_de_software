describe('CRUD Usuarios', () => {

    beforeEach(() => {

        cy.visit('https://app.blockcode.site/')

        // LOGIN
        cy.get('input[type="email"]')
            .type('admin@admin.com')

        cy.get('input[type="password"]')
            .type('1234@abc')

        cy.contains('Sign in')
            .click()

        // Esperar dashboard
        cy.url({ timeout: 15000 })
            .should('not.include', '/login')

        cy.wait(5000)

        // Ir directamente a users DESPUÉS del login
        cy.visit('https://app.blockcode.site/dashboard/users')

        cy.wait(3000)

    })

    it('Crear usuario', () => {

        cy.get('input[placeholder="Name"]')
            .should('be.visible')
            .type('Cypress')

        cy.get('input[placeholder="Last Name"]')
            .type('Testing')

        cy.get('input[placeholder="Second Last Name"]')
            .type('QA')

        cy.get('input[placeholder="Email"]')
            .type('cypress@test.com')

        cy.get('input[placeholder="Password"]')
            .type('123456')

        cy.get('select')
            .select(1)

        cy.contains('Create')
            .click()
        cy.wait(3000)

        cy.get('.modal-popup', { timeout: 10000 })
            .should('be.visible')

        // Click botón confirmar
        cy.get('.btn-confirm')
            .should('be.visible')
            .click()

        cy.wait(3000)

        cy.contains('Cypress', { timeout: 10000 })
            .should('exist')

    })

    it('Editar usuario', () => {

        cy.contains('td', 'Cypress')
            .parent()
            .find('.btn-edit')
            .click()

        cy.get('input[placeholder="Name"]')
            .clear()
            .type('Usuario Editado')

        cy.contains('Update')
            .click()
        cy.get('.modal-popup', { timeout: 10000 })
            .should('be.visible')

        // Click botón confirmar
        cy.get('.btn-confirm')
            .should('be.visible')
            .click()

        cy.contains('Usuario Editado', { timeout: 10000 })
            .should('exist')

    })

    it('Eliminar usuario', () => {

        cy.contains('td', 'Usuario Editado')
            .parent()
            .find('.btn-delete')
            .click()

        cy.get('.modal-popup', { timeout: 10000 })
            .should('be.visible')

        // Click botón confirmar
        cy.get('.btn-confirm')
            .should('be.visible')
            .click()

        cy.contains('Usuario Editado')
            .should('not.exist')

    })

})