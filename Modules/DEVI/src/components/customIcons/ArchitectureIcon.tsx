const ArchitectureIcon = ({ size = 24, color = "black" }) => {
    return (
        <svg
        xmlns="http://www.w3.org/2000/svg"
        fill={color}
        viewBox="0 0 100 100"
        width={size}
        height={size}
      >
        {/* <!-- Outer Rectangle (Building outline) --> */}
        <rect x="5" y="5" width="90" height="90" stroke={color} strokeWidth="3" fill="none" />
        
        {/* <!-- Inner Rectangle 1 (Room 1) --> */}
        <rect x="10" y="10" width="30" height="30" stroke={color} strokeWidth="2" fill="none" />
        
        {/* <!-- Inner Rectangle 2 (Room 2) --> */}
        <rect x="50" y="10" width="30" height="30" stroke={color} strokeWidth="2" fill="none" />
        
        {/* <!-- Inner Rectangle 3 (Room 3) --> */}
        <rect x="10" y="50" width="30" height="30" stroke={color} strokeWidth="2" fill="none" />
        
        {/* <!-- Flowchart-like arrows connecting rooms --> */}
        <line x1="40" y1="25" x2="50" y2="25" stroke={color} strokeWidth="2" markerEnd="url(#arrow)" />
        <line x1="25" y1="40" x2="25" y2="50" stroke={color} strokeWidth="2" markerEnd="url(#arrow)" />
        
        {/* <!-- Hallway (Center Cross) --> */}
        <line x1="40" y1="70" x2="90" y2="70" stroke={color} strokeWidth="3" />
        <line x1="70" y1="40" x2="70" y2="90" stroke={color} strokeWidth="3" />
        
        {/* <!-- Adding arrow markers for flowchart lines --> */}
        <defs>
          <marker id="arrow" markerWidth="10" markerHeight="10" refX="5" refY="5" orient="auto">
            <path d="M0,0 L10,5 L0,10 Z" fill={color} />
          </marker>
        </defs>
      </svg>
    );
  };
  
export default ArchitectureIcon;