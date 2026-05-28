describe('CRUD Projects', () => {

    beforeEach(() => {

        cy.visit('https://app.blockcode.site/')

        // LOGIN
        cy.get('input[type="email"]')
            .should('be.visible')
            .type('admin@admin.com')

        cy.get('input[type="password"]')
            .should('be.visible')
            .type('1234@abc')

        cy.contains('Sign in')
            .click()

        // Esperar dashboard
        cy.url({ timeout: 15000 })
            .should('not.include', '/login')

        cy.wait(3000)

        // Ir a projects
        cy.visit('https://app.blockcode.site/dashboard/projects')

        cy.wait(3000)

    })

    it('Crear proyecto y agregar transaccion', () => {

        // =========================
        // CREAR PROYECTO
        // =========================

        cy.get('input[placeholder="Project name"]')
            .should('be.visible')
            .type('Proyecto Cypress')

        cy.get('input[placeholder="Responsible"]')
            .type('Andrea')

        cy.get('input[name="fecha_inicio"]')
            .type('2026-06-01')

        cy.get('input[name="fecha_fin"]')
            .type('2026-12-31')

        cy.get('input[placeholder="Budget"]')
            .type('50000')

        cy.contains('Create')
            .click()

        // Confirmar modal
        cy.get('.modal-popup', { timeout: 10000 })
            .should('be.visible')

        cy.get('.btn-confirm')
            .click()

        cy.wait(3000)

        // VALIDAR CREACIÓN
        cy.contains('td', 'Proyecto Cypress', { timeout: 10000 })
            .should('exist')

        // =========================
        // MANAGE TRANSACCIONES
        // =========================

        cy.contains('td', 'Proyecto Cypress')
            .parent()
            .find('.btn-manage')
            .click()

        cy.wait(3000)

        // VALIDAR PANTALLA
        cy.contains('Transaction Management')
            .should('exist')

        // =========================
        // CREAR TRANSACCION
        // =========================

        cy.get('input[placeholder="Type"]')
            .type('Compra')

        cy.get('select')
            .select('2')

        cy.get('input[placeholder="Amount"]')
            .type('15000')

        cy.get('input[name="fecha"]')
            .type('2026-06-15')

        cy.get('input[placeholder="Description"]')
            .type('Compra de materiales')

        cy.contains('Create')
            .click()

        // Confirmar modal
        cy.get('.modal-popup', { timeout: 10000 })
            .should('be.visible')

        cy.get('.btn-confirm')
            .click()

        cy.wait(3000)

        // VALIDAR TRANSACCION
        cy.contains('td', 'Compra', { timeout: 10000 })
            .should('exist')

    })

    it('Editar proyecto', () => {

        cy.contains('td', 'Proyecto Cypress')
            .parent()
            .find('.btn-edit')
            .click()

        cy.get('input[placeholder="Project name"]')
            .clear()
            .type('Proyecto Editado')

        cy.get('input[placeholder="Budget"]')
            .clear()
            .type('80000')

        cy.contains('Update')
            .click()

        // Confirmar modal
        cy.get('.modal-popup', { timeout: 10000 })
            .should('be.visible')

        cy.get('.btn-confirm')
            .click()

        cy.wait(3000)

        // VALIDAR EDICIÓN
        cy.contains('td', 'Proyecto Editado', { timeout: 10000 })
            .should('exist')

    })

    it('Eliminar proyecto', () => {

        cy.contains('td', 'Proyecto Editado')
            .parent()
            .find('.btn-delete')
            .click()

        // Confirmar modal
        cy.get('.modal-popup', { timeout: 10000 })
            .should('be.visible')

        cy.get('.btn-confirm')
            .click()

        cy.wait(3000)

        // VALIDAR ELIMINACIÓN
        cy.contains('td', 'Proyecto Editado')
            .should('not.exist')

    })

})