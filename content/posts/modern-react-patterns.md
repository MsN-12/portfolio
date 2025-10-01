---
title: "Modern React Patterns: Building Scalable Applications in 2025"
date: 2025-01-27T14:00:00+00:00
draft: false
toc: true
images:
tags:
  - react
  - javascript
  - frontend
  - web-development
  - patterns
  - architecture
---

# Modern React Patterns: Building Scalable Applications in 2025

As React continues to evolve, so do the patterns and practices we use to build maintainable, scalable applications. In this post, I'll explore some of the most effective React patterns I've been using in production applications, along with practical examples and real-world use cases.

## The Evolution of React Patterns

React has come a long way since its introduction. With the introduction of Hooks, Suspense, and the upcoming Server Components, the way we structure our applications has fundamentally changed. Let's dive into the patterns that are making a real difference in modern React development.

## 1. Custom Hooks for Logic Abstraction

Custom hooks remain one of the most powerful patterns for sharing stateful logic between components.

### The Problem
```javascript
// ❌ Repeated logic across components
function UserProfile({ userId }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    async function fetchUser() {
      try {
        setLoading(true);
        const response = await api.getUser(userId);
        setUser(response.data);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    }
    fetchUser();
  }, [userId]);

  // Component logic...
}
```

### The Solution
```javascript
// ✅ Reusable custom hook
function useUser(userId) {
  const [state, setState] = useState({
    data: null,
    loading: true,
    error: null
  });

  useEffect(() => {
    let cancelled = false;
    
    async function fetchUser() {
      try {
        setState(prev => ({ ...prev, loading: true, error: null }));
        const response = await api.getUser(userId);
        
        if (!cancelled) {
          setState({ data: response.data, loading: false, error: null });
        }
      } catch (err) {
        if (!cancelled) {
          setState({ data: null, loading: false, error: err.message });
        }
      }
    }

    fetchUser();
    
    return () => {
      cancelled = true;
    };
  }, [userId]);

  return state;
}

// Clean component usage
function UserProfile({ userId }) {
  const { data: user, loading, error } = useUser(userId);
  
  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage error={error} />;
  
  return <div>{user.name}</div>;
}
```

## 2. Compound Components Pattern

This pattern allows you to create flexible, composable components that work together seamlessly.

```javascript
// ✅ Flexible compound component
const Modal = ({ children, isOpen, onClose }) => {
  if (!isOpen) return null;
  
  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content" onClick={e => e.stopPropagation()}>
        {children}
      </div>
    </div>
  );
};

const ModalHeader = ({ children }) => (
  <div className="modal-header">{children}</div>
);

const ModalBody = ({ children }) => (
  <div className="modal-body">{children}</div>
);

const ModalFooter = ({ children }) => (
  <div className="modal-footer">{children}</div>
);

// Attach sub-components
Modal.Header = ModalHeader;
Modal.Body = ModalBody;
Modal.Footer = ModalFooter;

// Usage
function App() {
  const [isOpen, setIsOpen] = useState(false);
  
  return (
    <Modal isOpen={isOpen} onClose={() => setIsOpen(false)}>
      <Modal.Header>
        <h2>Confirmation</h2>
      </Modal.Header>
      <Modal.Body>
        <p>Are you sure you want to delete this item?</p>
      </Modal.Body>
      <Modal.Footer>
        <button onClick={() => setIsOpen(false)}>Cancel</button>
        <button onClick={handleDelete}>Delete</button>
      </Modal.Footer>
    </Modal>
  );
}
```

## 3. Provider Pattern with Context

For state management across component trees without prop drilling.

```javascript
// ✅ Theme provider with context
const ThemeContext = createContext();

export const ThemeProvider = ({ children }) => {
  const [theme, setTheme] = useState('light');
  const [fontSize, setFontSize] = useState('medium');
  
  const toggleTheme = useCallback(() => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  }, []);
  
  const updateFontSize = useCallback((size) => {
    setFontSize(size);
  }, []);
  
  const value = useMemo(() => ({
    theme,
    fontSize,
    toggleTheme,
    updateFontSize
  }), [theme, fontSize, toggleTheme, updateFontSize]);
  
  return (
    <ThemeContext.Provider value={value}>
      <div className={`app-theme-${theme} font-${fontSize}`}>
        {children}
      </div>
    </ThemeContext.Provider>
  );
};

// Custom hook for consuming context
export const useTheme = () => {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
};
```

## 4. Render Props with Hooks

Combining render props with hooks for maximum flexibility.

```javascript
// ✅ Flexible data fetcher component
function DataFetcher({ url, children, fallback = null }) {
  const [state, setState] = useState({
    data: null,
    loading: true,
    error: null
  });

  useEffect(() => {
    let cancelled = false;
    
    async function fetchData() {
      try {
        setState(prev => ({ ...prev, loading: true, error: null }));
        const response = await fetch(url);
        const data = await response.json();
        
        if (!cancelled) {
          setState({ data, loading: false, error: null });
        }
      } catch (err) {
        if (!cancelled) {
          setState({ data: null, loading: false, error: err.message });
        }
      }
    }

    fetchData();
    
    return () => {
      cancelled = true;
    };
  }, [url]);

  if (state.loading) return fallback || <div>Loading...</div>;
  if (state.error) return <div>Error: {state.error}</div>;
  
  return children(state.data);
}

// Usage
function UserList() {
  return (
    <DataFetcher 
      url="/api/users"
      fallback={<UserListSkeleton />}
    >
      {users => (
        <ul>
          {users.map(user => (
            <li key={user.id}>{user.name}</li>
          ))}
        </ul>
      )}
    </DataFetcher>
  );
}
```

## 5. Error Boundaries with Hooks

Modern error handling patterns that work well with functional components.

```javascript
// ✅ Error boundary hook
function useErrorHandler() {
  const [error, setError] = useState(null);
  
  const resetError = useCallback(() => {
    setError(null);
  }, []);
  
  const handleError = useCallback((error) => {
    console.error('Caught error:', error);
    setError(error);
  }, []);
  
  useEffect(() => {
    if (error) {
      // Report to error tracking service
      reportError(error);
    }
  }, [error]);
  
  return { error, handleError, resetError };
}

// Error boundary component
class ErrorBoundary extends Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false, error: null };
  }
  
  static getDerivedStateFromError(error) {
    return { hasError: true, error };
  }
  
  componentDidCatch(error, errorInfo) {
    console.error('Error boundary caught:', error, errorInfo);
  }
  
  render() {
    if (this.state.hasError) {
      return this.props.fallback || (
        <div className="error-fallback">
          <h2>Something went wrong</h2>
          <p>{this.state.error?.message}</p>
          <button onClick={() => this.setState({ hasError: false, error: null })}>
            Try again
          </button>
        </div>
      );
    }
    
    return this.props.children;
  }
}
```

## 6. Optimistic Updates Pattern

For better user experience in applications with async operations.

```javascript
// ✅ Optimistic updates hook
function useOptimisticUpdate() {
  const [optimisticState, setOptimisticState] = useState({});
  
  const performOptimisticUpdate = useCallback(async (
    key,
    optimisticValue,
    asyncOperation
  ) => {
    // Apply optimistic update immediately
    setOptimisticState(prev => ({ ...prev, [key]: optimisticValue }));
    
    try {
      const result = await asyncOperation();
      // Replace optimistic value with real result
      setOptimisticState(prev => ({ ...prev, [key]: result }));
      return result;
    } catch (error) {
      // Revert optimistic update on failure
      setOptimisticState(prev => {
        const newState = { ...prev };
        delete newState[key];
        return newState;
      });
      throw error;
    }
  }, []);
  
  return { optimisticState, performOptimisticUpdate };
}

// Usage in a todo app
function TodoList() {
  const [todos, setTodos] = useState([]);
  const { optimisticState, performOptimisticUpdate } = useOptimisticUpdate();
  
  const addTodo = async (text) => {
    const tempId = `temp-${Date.now()}`;
    const optimisticTodo = { id: tempId, text, completed: false };
    
    try {
      const realTodo = await performOptimisticUpdate(
        tempId,
        optimisticTodo,
        () => api.createTodo({ text })
      );
      
      setTodos(prev => [...prev, realTodo]);
    } catch (error) {
      console.error('Failed to add todo:', error);
    }
  };
  
  const displayTodos = [
    ...todos,
    ...Object.values(optimisticState)
  ];
  
  return (
    <div>
      {displayTodos.map(todo => (
        <TodoItem key={todo.id} todo={todo} />
      ))}
    </div>
  );
}
```

## Performance Optimization Patterns

### Memoization Best Practices

```javascript
// ✅ Smart memoization
const ExpensiveComponent = memo(({ items, onSelect }) => {
  const expensiveValue = useMemo(() => {
    return items.reduce((acc, item) => acc + item.value, 0);
  }, [items]);
  
  const handleSelect = useCallback((item) => {
    onSelect(item.id);
  }, [onSelect]);
  
  return (
    <div>
      <p>Total: {expensiveValue}</p>
      {items.map(item => (
        <Item 
          key={item.id} 
          item={item} 
          onSelect={handleSelect} 
        />
      ))}
    </div>
  );
});

// Only re-render when items or onSelect actually change
const areEqual = (prevProps, nextProps) => {
  return (
    prevProps.items === nextProps.items &&
    prevProps.onSelect === nextProps.onSelect
  );
};

export default memo(ExpensiveComponent, areEqual);
```

## Testing These Patterns

```javascript
// ✅ Testing custom hooks
import { renderHook, act } from '@testing-library/react';
import { useUser } from './useUser';

describe('useUser', () => {
  it('should fetch user data', async () => {
    const mockUser = { id: 1, name: 'John Doe' };
    jest.spyOn(api, 'getUser').mockResolvedValue({ data: mockUser });
    
    const { result } = renderHook(() => useUser(1));
    
    expect(result.current.loading).toBe(true);
    
    await act(async () => {
      await new Promise(resolve => setTimeout(resolve, 0));
    });
    
    expect(result.current.loading).toBe(false);
    expect(result.current.data).toEqual(mockUser);
    expect(result.current.error).toBe(null);
  });
});
```

## Key Takeaways

1. **Custom Hooks**: Extract and reuse stateful logic across components
2. **Compound Components**: Build flexible, composable UI components
3. **Context + Hooks**: Manage shared state without prop drilling
4. **Error Boundaries**: Handle errors gracefully in your application
5. **Optimistic Updates**: Improve perceived performance with optimistic UX
6. **Smart Memoization**: Optimize performance where it matters most

## What's Next?

These patterns form the foundation of scalable React applications. In my next post, I'll dive deeper into **React Server Components** and how they're changing the way we think about React applications.

What patterns have you found most useful in your React projects? I'd love to hear about your experiences in the comments or reach out to me directly!

---

*Have questions about implementing these patterns? Feel free to [contact me](/contact) or check out the example implementations on my [GitHub](https://github.com/mohsenabdolahi).*