from graphviz import Digraph

# Create a new directed graph
dot = Digraph(comment='SV_PE_ctrl FSM')
dot.attr(rankdir='TB')  # Left to right layout
dot.attr(splines="spline")
dot.attr(ratio="full")


# Define state information
state_info = {
    'IDLE': '00',
    'IPSUM': '01',
    'OP': '10',
    'OPSUM': '11'
}

# Define colors
state_colors = {
    'IDLE': '#A8D8FF',    # Light blue
    'IPSUM': '#98FB98',   # Light green
    'OP': '#FFB6C1',      # Light red
    'OPSUM': '#DDA0DD'    # Light purple
}

# Set global node and edge attributes
dot.attr('node', 
        shape='circle', 
        fontsize='16', 
        width='1.2', 
        height='1.2',
        style='filled',
        fontname='Arial Bold')
dot.attr('edge', 
        fontsize='14',
        fontname='Arial',
        color='#404040',
        penwidth='1.5')

# Add main states with colors
for state in ['IDLE', 'IPSUM', 'OP', 'OPSUM']:
    dot.node(state, f'{state}\n({state_info[state]})', 
            fillcolor=state_colors[state])

# Add entry point and its transition
dot.attr('node', shape='point', width='0', height='0')
dot.node('entry', '')
dot.edge('entry', 'IDLE', '  RESET\n  (~rstn || kernel_size == 0)')

# Add state transitions
dot.edge('IDLE', 'IPSUM', '  READY')
dot.edge('IDLE', 'IDLE', '  !READY')
dot.edge('IPSUM', 'OP', '')
dot.edge('OP', 'OP', '  !out_valid')
dot.edge('OP', 'OPSUM', '  out_valid')
dot.edge('OPSUM', 'IPSUM', '  READY')
dot.edge('OPSUM', 'IDLE', '  !READY')

# Render the graph
dot.render('fsm_diagram', format='png', cleanup=True)
