Ext.define("TouchDocs.view.SlideNav", {
    extend: 'Ext.Container',
    xtype: 'mainContainer',

    config: {
        layout: 'fit',

        open: false,

        sideContainerWidth: 260,

        sideContainer: null,

        container: null
    },

    applySideContainer: function(config) {
        return Ext.factory(config);
    },

    updateSideContainer: function(newSideContainer, oldSideContainer) {
        if (newSideContainer) {
            this.add(newSideContainer);
        }

        if (oldSideContainer) {
            this.remove(oldSideContainer);
        }
    },

    applyContainer: function(config) {
        return Ext.factory(config);
    },

    updateContainer: function(newContainer, oldContainer) {
        this.getSideContainer();

        if (newContainer) {
            newContainer.setZIndex(100);
            this.add(newContainer);

            newContainer.element.on({
                tap: this.onContainerTap,
                dragstart: this.onDragStart,
                drag: this.onDrag,
                dragend: this.onDragEnd,
                scope: this
            });
        }

        if (oldContainer) {
            this.remove(oldContainer);
        }
    },

    toggle: function() {
        if (this.getOpen()) {
            this.setOpen(false);
        } else {
            this.setOpen(true);
        }
    },

    onContainerTap: function(e) {
        if (!this.getOpen()) {
            return;
        }

        this.setOpen(false);
        e.stopEvent();
    },

    onDragStart: function(e) {
        var touch = e.changedTouches[0],
            startX = touch.pageX;

        if (startX < 25 && !this.getOpen()) {
            this.canOpen = true;
        } else {
            this.canOpen = false;
            this.onContainerTap(e);
        }
    },

    onDrag: function(e) {
        var touch = e.changedTouches[0],
            startX = Math.min(touch.pageX, this.getSideContainerWidth());

        if (this.canOpen) {

            console.log('left', startX);
            this.getContainer().element.setStyle('-webkit-transform', 'translateX(' + startX + 'px)')
        }
    },

    onDragEnd: function(e) {
        this.canOpen = false;

        var touch = e.changedTouches[0],
            startX = Math.min(touch.pageX, this.getSideContainerWidth()),
            sideContainerWidth = this.getSideContainerWidth();

        if (startX > (sideContainerWidth / 2)) {
            this.updateOpen(true);
        } else {
            this.updateOpen(false);
        }
    },

    updateOpen: function(newOpen) {
        var container = this.getContainer();

        if (!this.initialized || !container) {
            return;
        }

        if (newOpen) {
            this.animate(true);
        } else {
            this.animate();
        }
    },

    animate: function(open) {
        var container = this.getContainer();

        Ext.Animator.run({
            element: container.element,
            easing: 'ease-out',
            duration: 250,
            to: {
                transform: {
                    translateX: (open) ? 260 : 0
                }
            },
            preserveEndState: true
        });
    }
});