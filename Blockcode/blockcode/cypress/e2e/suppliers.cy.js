describe('CRUD Suppliers', () => {

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

        // Ir directamente a suppliers
        cy.visit('https://app.blockcode.site/dashboard/suppliers')

        cy.wait(3000)

    })

    it('Crear proveedor', () => {

        cy.get('input[placeholder="Supplier Name"]')
            .should('be.visible')
            .type('Proveedor Cypress')

        cy.get('input[placeholder="Contact Person"]')
            .type('Juan Perez')

        cy.get('input[placeholder="Phone Number"]')
            .type('4421234567')

        cy.get('input[placeholder="Email"]')
            .type('proveedor@cypress.com')

        cy.contains('Create')
            .click()

        cy.wait(3000)

        cy.get('.modal-popup', { timeout: 10000 })
            .should('be.visible')

        // Confirmar
        cy.get('.btn-confirm')
            .should('be.visible')
            .click()

        cy.wait(3000)

        cy.contains('Proveedor Cypress', { timeout: 10000 })
            .should('exist')

    })

    it('Editar proveedor', () => {

        cy.contains('td', 'Proveedor Cypress')
            .parent()
            .find('.btn-edit')
            .click()

        cy.get('input[placeholder="Supplier Name"]')
            .clear()
            .type('Proveedor Editado')

        cy.get('input[placeholder="Contact Person"]')
            .clear()
            .type('Maria Lopez')

        cy.contains('Update')
            .click()

        cy.get('.modal-popup', { timeout: 10000 })
            .should('be.visible')

        // Confirmar
        cy.get('.btn-confirm')
            .should('be.visible')
            .click()

        cy.contains('Proveedor Editado', { timeout: 10000 })
            .should('exist')

    })

    it('Eliminar proveedor', () => {

        cy.contains('td', 'Proveedor Editado')
            .parent()
            .find('.btn-delete')
            .click()

        cy.get('.modal-popup', { timeout: 10000 })
            .should('be.visible')

        // Confirmar
        cy.get('.btn-confirm')
            .should('be.visible')
            .click()

        cy.contains('Proveedor Editado')
            .should('not.exist')

    })

})