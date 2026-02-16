import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  connect() {
    this.element.addEventListener('keydown', this.handleKeydown.bind(this));

    // Set first node as focusable
    const firstNode = this.visibleNodes()[0];
    if (firstNode) {
      firstNode.setAttribute('tabindex', '0');
    }
  }

  disconnect() {
    this.element.removeEventListener('keydown', this.handleKeydown.bind(this));
  }

  selectNode(event) {
    event.stopPropagation();
    const node = event.currentTarget;

    if (node.getAttribute('aria-disabled') === 'true') {
      return;
    }

    // Update selection
    if (!this.element.getAttribute('aria-multiselectable')) {
      this.element.querySelectorAll('[role="treeitem"]').forEach((item) => {
        item.classList.remove('cds--tree-node--selected');
        item.setAttribute('aria-selected', 'false');
        item.setAttribute('tabindex', '-1');
      });
    }

    node.classList.toggle('cds--tree-node--selected');
    const isSelected = node.classList.contains('cds--tree-node--selected');
    node.setAttribute('aria-selected', isSelected.toString());
    node.setAttribute('tabindex', '0');
    node.focus();
  }

  toggleNode(event) {
    event.stopPropagation();
    const toggle = event.currentTarget;
    const node = toggle.closest('[role="treeitem"]');

    if (node.getAttribute('aria-disabled') === 'true') {
      return;
    }

    const isExpanded = node.getAttribute('aria-expanded') === 'true';
    node.setAttribute('aria-expanded', (!isExpanded).toString());

    const children = node.querySelector('.cds--tree-node__children');
    if (children) {
      if (isExpanded) {
        children.classList.add('cds--tree-node--hidden');
      } else {
        children.classList.remove('cds--tree-node--hidden');
      }
    }

    const icon = toggle.querySelector('.cds--tree-parent-node__toggle-icon');
    if (icon) {
      icon.classList.toggle('cds--tree-parent-node__toggle-icon--expanded', !isExpanded);
    }
  }

  handleKeydown(event) {
    const nodes = this.visibleNodes();
    const currentNode = event.target.closest('[role="treeitem"]');
    const currentIndex = nodes.indexOf(currentNode);

    switch (event.key) {
      case 'ArrowDown': {
        event.preventDefault();
        const nextIndex = currentIndex < nodes.length - 1 ? currentIndex + 1 : currentIndex;
        this.focusNode(nodes[nextIndex], nodes);
        break;
      }
      case 'ArrowUp': {
        event.preventDefault();
        const prevIndex = currentIndex > 0 ? currentIndex - 1 : 0;
        this.focusNode(nodes[prevIndex], nodes);
        break;
      }
      case 'ArrowRight': {
        event.preventDefault();
        if (currentNode && currentNode.getAttribute('aria-expanded') === 'false') {
          // Expand collapsed parent
          const toggle = currentNode.querySelector('.cds--tree-parent-node__toggle');
          if (toggle) {
            toggle.click();
          }
        } else if (currentNode && currentNode.getAttribute('aria-expanded') === 'true') {
          // Move to first child
          const childNodes = this.visibleNodes();
          const newIndex = childNodes.indexOf(currentNode);
          if (newIndex < childNodes.length - 1) {
            this.focusNode(childNodes[newIndex + 1], childNodes);
          }
        }
        break;
      }
      case 'ArrowLeft': {
        event.preventDefault();
        if (currentNode && currentNode.getAttribute('aria-expanded') === 'true') {
          // Collapse expanded parent
          const toggle = currentNode.querySelector('.cds--tree-parent-node__toggle');
          if (toggle) {
            toggle.click();
          }
        } else if (currentNode) {
          // Move to parent
          const parentGroup = currentNode.parentElement;
          if (parentGroup && parentGroup.classList.contains('cds--tree-node__children')) {
            const parentNode = parentGroup.closest('[role="treeitem"]');
            if (parentNode) {
              const allNodes = this.visibleNodes();
              this.focusNode(parentNode, allNodes);
            }
          }
        }
        break;
      }
      case 'Home': {
        event.preventDefault();
        this.focusNode(nodes[0], nodes);
        break;
      }
      case 'End': {
        event.preventDefault();
        this.focusNode(nodes[nodes.length - 1], nodes);
        break;
      }
      case 'Enter':
      case ' ': {
        event.preventDefault();
        if (currentNode) {
          currentNode.click();
        }
        break;
      }
    }
  }

  focusNode(node, allNodes) {
    if (!node) return;

    allNodes.forEach((n) => n.setAttribute('tabindex', '-1'));
    node.setAttribute('tabindex', '0');
    node.focus();
  }

  visibleNodes() {
    const nodes = [];
    const walk = (parent) => {
      const items = parent.querySelectorAll(':scope > [role="treeitem"], :scope > li > [role="treeitem"]');
      items.forEach((item) => {
        nodes.push(item);
        if (item.getAttribute('aria-expanded') === 'true') {
          const children = item.querySelector('[role="group"]');
          if (children) {
            walk(children);
          }
        }
      });
    };
    walk(this.element);
    return nodes;
  }
}
