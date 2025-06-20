const { createApp } = Vue;

createApp({
    data() {
        return {
            showMenu: false,
            activeTab: 'list',
            blips: [],
            commonColors: [],
            commonSprites: [],
            searchQuery: '',
            
            // New blip form
            newBlip: {
                name: 'New Blip',
                sprite: 1,
                color: 0,
                scale: 0.8
            },
            customSprite: 1,
            customColor: 0,
            
            // Edit blip form
            editingBlip: null,
            editCustomSprite: 1,
            editCustomColor: 0,
            
            // Delete confirmation
            showDeleteModal: false,
            deleteBlip: null
        };
    },
    
    computed: {
        filteredBlips() {
            if (!this.searchQuery) return this.blips;
            
            const query = this.searchQuery.toLowerCase();
            return this.blips.filter(blip => 
                blip.name.toLowerCase().includes(query) || 
                blip.sprite.toString().includes(query) || 
                blip.color.toString().includes(query)
            );
        }
    },
    
    methods: {
        // Close the menu
        closeMenu() {
            fetch('https://ec-blips/closeMenu', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({})
            });
        },
        
        // Create a new blip
        createBlip() {
            if (!this.newBlip.name) {
                this.newBlip.name = 'New Blip';
            }
            
            fetch('https://ec-blips/createBlip', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(this.newBlip)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    this.blips = data.blips;
                }
                this.activeTab = 'list';
                
                // Reset form
                this.newBlip = {
                    name: 'New Blip',
                    sprite: 1,
                    color: 0,
                    scale: 0.8
                };
                this.customSprite = 1;
                this.customColor = 0;
            });
        },
        
        // Edit a blip
        editBlip(blip) {
            this.editingBlip = { ...blip };
            this.editCustomSprite = blip.sprite;
            this.editCustomColor = blip.color;
            this.activeTab = 'edit';
        },
        
        // Save edited blip
        saveBlip() {
            if (!this.editingBlip) return;
            
            fetch('https://ec-blips/updateBlip', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(this.editingBlip)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update local blip data
                    const index = this.blips.findIndex(b => b.id === this.editingBlip.id);
                    if (index !== -1) {
                        this.blips[index] = { ...this.editingBlip };
                    }
                    
                    this.cancelEdit();
                }
            });
        },
        
        // Cancel editing
        cancelEdit() {
            this.editingBlip = null;
            this.activeTab = 'list';
        },
        
        // Confirm delete modal
        confirmDelete(blip) {
            this.deleteBlip = blip;
            this.showDeleteModal = true;
        },
        
        // Delete blip confirmed
        deleteBlipConfirmed() {
            if (!this.deleteBlip) return;
            
            fetch('https://ec-blips/deleteBlip', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({
                    id: this.deleteBlip.id
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Remove from local blips array
                    this.blips = this.blips.filter(b => b.id !== this.deleteBlip.id);
                }
                
                this.showDeleteModal = false;
                this.deleteBlip = null;
            });
        },
        
        // Find nearest blip
        findNearestBlip() {
            fetch('https://ec-blips/getNearestBlip', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({})
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    this.editBlip(data.blip);
                } else {
                    // Show notification that no blips were found nearby
                    console.log(data.message);
                }
            });
        }
    },
    
    mounted() {
        // Listen for NUI messages
        window.addEventListener('message', (event) => {
            const data = event.data;
            
            if (data.action === 'openMenu') {
                this.showMenu = true;
                this.blips = data.blips || [];
                this.commonColors = data.commonColors || [];
                this.commonSprites = data.commonSprites || [];
                this.activeTab = 'list';
            } else if (data.action === 'closeMenu') {
                this.showMenu = false;
            }
        });
        
        // Close on escape key
        document.addEventListener('keydown', (event) => {
            if (event.key === 'Escape' && this.showMenu) {
                this.closeMenu();
            }
        });
    }
}).mount('#app');
